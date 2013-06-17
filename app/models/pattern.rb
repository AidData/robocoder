class Pattern < ActiveRecord::Base
  attr_accessible :code, :regex

  validates :regex, presence: true
end
