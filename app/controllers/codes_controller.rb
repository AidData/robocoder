class CodesController < ApplicationController
  def index
    @purpose_codes = Code.purpose_codes
    @activity_codes = Code.activity_codes
  end

  def new
    @code = Code.new
  end

  def create
    #allows activity codes with decimals to be added
    params[:code][:number] = params[:code][:number].to_s.delete(".").to_i

    @code = Code.new(params[:code])
    if @code.save
      flash[:notice] = "Code has been created"
      redirect_to @code
    else
      flash[:alert] = "Code has not been created"
      render action: "new"
    end
  end

  def show
    @code = Code.find(params[:id])
  end
end
