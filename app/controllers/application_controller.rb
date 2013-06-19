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
end
