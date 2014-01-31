require 'uri'
require 'net/http'

class StaticController < ApplicationController
  include StringStripper

  def classify
    desc = params[:description]
    sector_code = desc[0,3]
    desc = clean_string(desc)
    desc << ' '
    desc.insert(0, ' ')

    #look in application controller for this function
    matches = roboclassify(desc)

    # if roboclassify returns nothing or '31105' then do tf-idf (term frequency)
    if matches.empty? || (matches[0].number==31105)
      puts("Empty")
      tfidf_matches = tfidf_classify(desc,sector_code)
      tfidf_matches.each do |code_string|
        if Code.exists?( code_string.gsub(/\./, ''))
          matches <<  Code.find( code_string.gsub(/\./, ''))
        end
      end
    end

    puts matches.inspect
    # remove purpose codes from array
    matches = matches.select { |code| code.number> 999999 }

    #?Replace with call to unique?
    @code_matches = []
    matches.each do |match|
      @code_matches << match unless @code_matches.index { |x| x.number == match.number }
    end

    if @code_matches.empty?
      @code_matches = "no matches"
      @json_response = []
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
