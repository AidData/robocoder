module CodesHelper
  def formatted_code_number(code)
    num = code.number
    if code.type == "activity"
      return "#{num / 100}.#{num % 100}"
    else
      return num.to_s
    end
  end
end
