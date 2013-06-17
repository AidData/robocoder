class Code < ActiveRecord::Base
  attr_accessible :name, :number
  set_primary_key :number

  has_many :patterns, dependent: :delete_all

  validates :name, presence: true
  validates_presence_of :number
  validates_uniqueness_of :number


  def type
    case number.to_s.length
    when 7
      "activity"
    when 5
      "purpose"
    when 3
      "sector"
    when 1
      "supersector"
    else
      "unknown"
    end
  end

  def self.activity_codes
    activity = []
    Code.all.each do |code|
      activity << code if code.type == "activity"
    end
    activity
  end

  def self.purpose_codes
    purpose = []
    Code.all.each do |code|
      purpose << code if code.type == "purpose"
    end
    purpose
  end

end
