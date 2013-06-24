class Match < ActiveRecord::Base
  attr_accessible :words, :unordered, :complete_text, :plural

  has_and_belongs_to_many :codes

  def all_word_combinations
    combos = []
    combos << words
    regex = /\([^\|]+\|[^)]+\)/
    combos.delete_if do |combo|
      #find (option1|option2) groups
      matchdata = regex.match combo
      next if matchdata.nil?

      indexes = matchdata.offset(0)
      beginning = indexes[0]
      ending = indexes[1]

      a_part = ""
      c_part = ""
      a_part = combo[0...beginning] if beginning > 0
      c_part = combo[ending..-1] if ending < combo.size - 1

      or_string = matchdata[0]
      or_string.gsub!(/(\(|\))/, '')
      options = or_string.split('|')
      options.each do |option|
        combos << a_part + option + c_part
      end
      #delete the element if it made it this far
      true
    end

    # fill in abbreviations
    combos.each do |combo|
      Abbreviation.all.each do |ab|
        if combo.include?(ab.word)
          ab.abbreviations.each do |a|
            combos << combo.gsub(ab.word, a)
          end
        end
      end
    end

    # Get plurals
    if plural
      plurals = []
      combos.each do |combo|
        plurals << Shellwords.split(combo).map(&:pluralize).join(' ')
      end
      combos += plurals
    end

    # unordered
    if unordered
      temp = []
      #put all permutations into subarrays
      combos.each do |combo|
        split_words = Shellwords.split(combo)
        temp += split_words.permutation.to_a
      end

      combos = temp.map {|t| t.join(' ') }
    end

    # get rid of quotes
    combos.each do |combo|
      combo.gsub!("'", '')
    end

    combos
  end
end
