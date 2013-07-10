require 'uri'
require 'net/http'

class StaticController < ApplicationController
  include StringStripper

  def classify
    desc = params[:description]
    desc = clean_string(desc)
    desc << ' '
    desc.insert(0, ' ')

    #look in application controller for this function
    matches = roboclassify(desc)
    if matches.empty?
      term_params = {description: desc}
      term_result = Net::HTTP.post_form(URI.parse('http://robocode.adamfrey.me'), term_params)
      if term_result.code == '200'
        body = term_result.body
        response_hash = JSON.parse(body)
        term_code_strings = response_hash.map {|r| r["code"]}
        term_code_strings.each do |code_string|
          matches <<  Code.find(code_string.gsub(/\./, ''))
        end
      else
      end
    end

    @code_matches = []
    matches.each do |match|
      @code_matches << match unless @code_matches.index { |x| x.number == match.number }
    end

    if @code_matches.empty?
      @code_matches = "no matches"
      @json_response = "no matches"
    else
      @json_response = @code_matches.map {|m| {name: m.name, number: m.number,
                                            formatted_number: m.formatted_number}}
    end

    respond_to do |format|
      format.html { redirect_to controller: 'static',
                                action: 'robocode',
                                result: @code_matches
                  }
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
