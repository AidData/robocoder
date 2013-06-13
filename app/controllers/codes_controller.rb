class CodesController < ApplicationController
  def index
    @purpose_codes = Code.purpose_codes
    @activity_codes = Code.activity_codes
  end

  def new
    @code = Code.new
  end

  def create
    @code = Code.create(params[:code])
    redirect_to @code
  end

  def show
    @code = Code.find(params[:id])
  end
end
