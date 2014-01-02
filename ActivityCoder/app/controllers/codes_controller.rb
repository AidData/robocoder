class CodesController < ApplicationController
  def index
    if params.has_key?("term")
      @codes = Code.order(:number).where("cast(number as text) like ?", "%#{params[:term]}%")
      @codes = @codes + Code.order(:name).where("name ilike ?", "%#{params[:term]}%")
      render json: @codes.map {|c| c.full_name }
    else
      @purpose_codes = Code.purpose_codes
      @activity_codes = Code.activity_codes
    end
  end

  def new
    @code = Code.new
  end

  def create
    #allows activity codes with decimals to be added
    num_string = params[:code][:number]
    num_string = num_string.to_s.delete(".")
    num = num_string.to_i
    params[:code][:number] = num

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
