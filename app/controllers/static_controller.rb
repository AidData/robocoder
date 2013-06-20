class StaticController < ApplicationController
  def classify
    desc = params[:description]
    desc.strip!
    desc << ' '
    desc.insert(0, ' ')

    #look in application controller for this function
    @pat_matches = roboclassify(desc)
    @json_response = @pat_matches.map {|m| {name: m.name, number: m.number,
                                            formatted_number: m.formatted_number}}
    @pat_matches = "no matches" if @pat_matches.empty?
    respond_to do |format|
      format.html { redirect_to controller: 'static', action: 'robocode', result: @pat_matches }
      format.json { render json: @json_response }
    end
  end

  def robocode
    results = params[:result]
    if results.nil?
      #no flash
    elsif results == "no matches"
      flash[:success] = "Robocoder could not classify this description"
    else
      result_string = ""
      results.each do |code_id|
        c = Code.find(code_id)
        result_string << "#{c.full_name} "
      end
      flash[:notice] = "Robocoder guesses " + result_string
    end
  end

end
