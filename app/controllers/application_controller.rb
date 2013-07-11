require 'stopwords'
require 'ffi/hunspell'
include Mongo

class ApplicationController < ActionController::Base
  protect_from_forgery

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
  def tfidf_classify(desc)
    #get the collections
    @coll = get_connection["words_index"]
    @count_coll = get_connection["document_count"]
    @max_count = get_connection["max_count"]

    # clean up description
    desc.downcase!
    desc.gsub! /\//, ' '
    desc.gsub! /-/, ' '
    desc.gsub! /[^a-zA-Z\s]/, ''
    desc.strip!
    desc.gsub!(/\s+/, ' ')
    words = desc.split /\s/

    final_words = []

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

    # store aggregated tf-idf scores for each code here
    master_index = {}

    words.each do |word|
      word_entry = @coll.find_one('word' => word)
      next if word_entry.nil?
      word_row = word_entry["codes"]
      next if word_row.empty?

      #Calculate Inverse Document frequency
      count_entry = @count_coll.find_one('word' => word)
      count = count_entry["count"]

      quotient = TOTAL_COUNT.to_f / count.to_f + 1
      idf = Math.log(quotient)

      #Calculate Term frequency and update tf-idf
      word_row.each do |code, num|
        max_count_entry = @max_count.find_one({"code" => code})
        max_count = max_count_entry["count"]

        next if max_count == 0
        tf = 0.5 + ((0.5 * num) / max_count)
        tfidf = tf * idf
        next if tfidf == Float::INFINITY

        master_index[code] ||= 0
        master_index[code] += tfidf
      end

    end

    # sort to get top codes
    tf_index = master_index.sort_by {|k,v| -v}

    #fix code name formatting
    results = tf_index[0..10].map do |x|
      code_name = x[0].dup
      code_name.gsub!(/code_/,'')
      code_name.insert(5, '.') if code_name.length == 7
      x[0] = code_name
      x
    end

    # give just the results
    results.map {|r| r[0]}
  end
end
