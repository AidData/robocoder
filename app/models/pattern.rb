class Pattern < ActiveRecord::Base
  attr_accessible :regex

  has_and_belongs_to_many :codes

  validates :regex, presence: true
end
