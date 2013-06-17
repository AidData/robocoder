class StaticController < ApplicationController
  def classify
    desc = params[:description]
    @matches = []
    Pattern.all.each do |pattern|
      @matches << pattern.code_id if regex(pattern).match(desc)
    end
    if @mathces.empty?
      @matches = "no matches"
    end
    redirect_to controller: 'static', action: 'robocode', result: @matches
  end

  def robocode
    results = params[:result]
    if results.nil?
      #no flas:
    elsif results == "no matches"
      flash[:success] = "Robocoder could not classify this description"
    else
      result_string = ""
      results.each do |code_id|
        code_name = Code.find(code_id).name
        result_string << "#{code_id} - #{code_name}"
      end
      flash[:notice] = "Robocoder guesses " + result_string
    end
  end
end
