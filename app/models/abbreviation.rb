class Abbreviation < ActiveRecord::Base
  attr_accessible :word, :abbreviations
  serialize :abbreviations, Array

  before_save :lowercase
  before_save :delete_blanks

  private

  def lowercase
    self.word = word.downcase
    self.abbreviations = abbreviations.map(&:downcase)
  end

  def delete_blanks
    self.abbreviations = abbreviations.delete_if {|a| a.empty? }
  end
end
