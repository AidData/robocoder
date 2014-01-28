module StringStripper
  def clean_string(desc)
    desc.downcase!
    desc.gsub!("%20", " ")
    desc.gsub!('"', "'")
    desc.gsub!(/(\/|-)/, ' ')
    desc.gsub!(/[^a-zA-Z\s]/, '')

    # get rid of html
    desc.gsub!(/(\sbr|br\s)/, '')

    desc.strip!
    desc.gsub!(/\s+/, ' ')
    #stop repeating strings
    letters = desc.gsub(' ','')
    result = letters.scan(/^(.+)\1+/)
    if not result.empty?
      substring = result.first.first
      position = 0
      sub_position = 0
      while xx = substring[sub_position]
        if desc[position] == xx
          sub_position += 1
        end

        position += 1
      end

      desc = desc[0..position]
    end

    desc.strip
  end
end
