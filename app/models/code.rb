class Code < ActiveRecord::Base
  attr_accessible :name, :number

  def type
    case number.length
    when 8
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
