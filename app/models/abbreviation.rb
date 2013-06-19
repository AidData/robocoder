class Abbreviation < ActiveRecord::Base
  attr_accessible :abbreviations, :word
  serialize :abbreviations
end
