include Mongo

class ApplicationController < ActionController::Base
  protect_from_forgery

  def regex(pattern)
    Regexp.new pattern.regex
  end

  def roboclassify(desc)
    @pat_matches = []
    Pattern.all.each do |pattern|
      @pat_matches += pattern.codes if regex(pattern).match(desc)
    end
    @pat_matches
  end

  def get_connection
    return @db_connection if @db_connection
    mongo_client = MongoClient.new("localhost", 27017)
    @db_connection = mongo_client.db("robocoder")
  end

  def tfidf_classify(desc)
    #get the collections
    @coll = get_connection["words_index"]
    @count_coll = get_connection["document_count"]
    @max_count = get_connection["max_codes"]

    # clean up description
    desc.downcase!
    desc.gsub! /\//, ' '
    desc.gsub! /-/, ' '
    desc.gsub! /[^a-zA-Z\s]/, ''
    desc.strip!
    desc.gsub!(/\s+/, ' ')
    words = desc.split /\s/

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
        max_count = max_count_entry["max_count"]

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
