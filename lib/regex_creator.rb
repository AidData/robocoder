require 'shellwords'

module RegexCreator
  #expects a match object
  def regex_create(match)
    regex_string = ""
    sentence = match.words.strip.downcase
    words = Shellwords.split(sentence)

    #plurals
    if match.plural
      words.map!{ |w| "(#{w}|#{w.pluralize})" }
    end

    #in any order
    if match.unordered
      words.each do |word|
        regex_string << "(?=.*\s#{word}\s)"
      end
    end

    #strict order
    if regex_string.empty?
      regex_string << words.join(' ')
    end

    if match.complete_text
      regex_string.insert(0, "^ ")
      regex_string << " $"
    end

    { regex: regex_string }
  end
end
