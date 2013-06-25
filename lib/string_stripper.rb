module StringStripper
  def clean_string(desc)
    desc = desc.downcase
    desc.gsub!('"', "'")
    desc.gsub!(/\W/, ' ')

    # get rid of html
    desc.gsub!(/\sbr\s/, '')

    # get rid of leading numbers
    desc.gsub!(/^\d+\s/, '')

    desc
  end
end
