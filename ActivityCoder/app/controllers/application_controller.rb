require 'stopwords'
require 'ffi/hunspell'
include Mongo

class ApplicationController < ActionController::Base
  protect_from_forgery

#TODO acronyms are stripped from description...see if also stripped from mongo.

  # Takes the "regex" string and turns it into a real Regex
  def regex(pattern)
    Regexp.new pattern.regex
  end

  # Checks a description against all patterns that have been inputted
  # Outputs an array of Codes
  def roboclassify(desc)
    @pat_matches = []
    Pattern.all.each do |pattern|
      @pat_matches += pattern.codes if regex(pattern).match(desc)
    end
    @pat_matches
  end

  # connect to the Mongo Database for tf-idf classifying
  def get_connection
    return @db_connection if @db_connection
    mongo_client = MongoClient.new("localhost", 27017)
    @db_connection = mongo_client.db("robocoder2")
  end

  # STAGE 2 CLASSIFYING: Term Frequency Inverse Document Frequency
  def tfidf_classify(desc, sector_code)
    #get the collections
    @coll = get_connection["words_index"]
    @count_coll = get_connection["document_count"]
    @max_count = get_connection["max_count"]

    # split description into array of words
    words = desc.split /\s/

    final_words = []

puts("1")
    # TODO print words before and after to see what it strips out.
    # TODO try stripping out.
    FFI::Hunspell.dict do |dict|
      desc.split(/\s/).each do |word|
        if PASSABLE_WORDS.include? word
          final_words << word
          next
        end

        next unless Stopwords.valid? word

        if dict.check? word
          stems = dict.stem word
          final_words << (dict.stem word).last
        end
      end
    end

    words = final_words
	puts words

    # store aggregated tf-idf scores for each code here
    master_index = {}

    i = 0

	b = Hash.new(0)
	words.each do |v|
	    b[v] += 1
	end

	b.each do |k,v|
	    puts "#{k} appears #{v} times"
    end

	tfidfs = Hash.new(0)
	
    words.each do |word|
        i = i+1
        next if i==5000
      word_entry = @coll.find_one('word' => word)
      next if word_entry.nil?
      word_row = word_entry["codes"]
      next if word_row.empty?

      #Calculate Inverse Document frequency
      count_entry = @count_coll.find_one('word' => word)
      count = count_entry["count"]

      quotient = TOTAL_COUNT.to_f / count.to_f + 1
      idf = Math.log(quotient)

	  num = b[word]
	  #puts words.length
	  tf = 0.5 + ((0.5 * num)/ words.length)
	  tfidf = tf * idf
	  puts word
	  puts tfidf
	  tfidfs[word] = tfidf


#puts word_row.length
      #Calculate Term frequency and update tf-idf

    
    end
	tfidfs = tfidfs.sort_by {|k,v| -v}

	important_words = tfidfs

    aggregate_code_scores = Hash.new(0)

	threshold=0
    important_words.each do |word,score|
		threshold += 1
		break if threshold > 20
      word_entry =  @coll.find_one('word' => word)
      next if word_entry.nil?
      word_codes = word_entry["codes"]
      next if word_codes.empty?

      word_codes.each do |code, num|
        aggregate_code_scores[code] += num
      end
    end

    #sort aggregate codes
    aggregate_code_scores = aggregate_code_scores.sort_by {|k,v| -v}

    puts 'important words'
    puts aggregate_code_scores[0..3].inspect
    puts '=============='

	tf_index = aggregate_code_scores[0..30]

#TODO to print size of tf_index

    #fix code name formatting
    results = tf_index[0..10].map do |x|
      code_name = x[0].dup
      code_name.gsub!(/code_/,'')
      code_name.insert(5, '.') if code_name.length == 7
      x[0] = code_name
      x
    end

    # give just the results
    pruned_results(results.map {|r| r[0]}, sector_code)
  end

  def pruned_results(results, sector_code)

    guesses = results.dup
    final_codes = []

    # trim guesses to subest of sector code.
    # if (Float(sector_code) rescue false)
    #   puts sector_code
    #   guesses = guesses.select { |code| code[0,3] == sector_code }
    # end

    if guesses.length > 0

      index = guesses.index {|x| x=~ /\d{5}$/ }
      if not index
        purpose_code = guesses[0][0..4]
        final_codes << purpose_code
      else
        purpose_code = guesses[index]
      end


      guesses.each do |guess|
        if guess.include? purpose_code
          final_codes << guess
        end
      end

      if final_codes.size == 1
        final_codes << "#{purpose_code}.01"
      end

      # TODO try returning up to a threshold instead of just 2.
      puts guesses.inspect

      for i in 0..1
        if(guesses.length >i)
          second_code = guesses[i]
          final_codes << second_code if (not final_codes.include? second_code) && (second_code.size != 5)
        end
      end

    end

    if final_codes.length == 0
      final_codes << "#00000.01"
    end

    final_codes.uniq
  end
end
