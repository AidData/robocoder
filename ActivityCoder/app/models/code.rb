class Code < ActiveRecord::Base
  attr_accessible :name, :number
  self.primary_key = "number"

  has_and_belongs_to_many :patterns
  has_and_belongs_to_many :matches

  validates :name, presence: true
  validates_presence_of :number
  validates_uniqueness_of :number

  scope :activity_codes, -> { where("number > 999999")}
  scope :purpose_codes, -> {where("number between 999 and 1000000")}
  scope :sector_codes, -> {where("number between 9 and 1000")}
  scope :supersector_codes, -> {where("number < 10")}

  def formatted_number
    if type == "activity"
      "#{number.to_s[0..4]}.#{number.to_s[5..6]}"
    else
      number.to_s
    end
  end

  def full_name
    "#{formatted_number} - #{name}"
  end

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
end
