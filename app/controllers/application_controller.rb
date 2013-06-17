class ApplicationController < ActionController::Base
  protect_from_forgery

  def regex(pattern)
    Regexp.new pattern.regex
  end
end
