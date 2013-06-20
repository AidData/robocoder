class AbbreviationsController < ApplicationController

  before_filter :find_abbreviation, only: [:show, :edit, :update, :destroy]

  def new
    @abbrev = Abbreviation.new
  end

  def create
    abbrev_params = params["abbreviation"]
    abbrev_params["abbreviations"] = abbrev_params["abbreviations"].values
    @abbrev = Abbreviation.new(abbrev_params)
    if @abbrev.save
      redirect_to @abbrev
    else
      flash[:alert] = "Abbreviation could not be saved"
      render action: "new"
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @abbrev }
    end
  end

  def index
    @abbrevs = Abbreviation.all
  end

  def edit
  end

  def update
    abbrev_params = params["abbreviation"]
    abbrev_params["abbreviations"] = abbrev_params["abbreviations"].values
    @abbrev.update_attributes(abbrev_params)
    if @abbrev.save
      redirect_to @abbrev
    else
      flash[:alert] = "Abbreviation could not be saved"
      render action: "new"
    end
  end

  private

  def find_abbreviation
    @abbrev = Abbreviation.find(params[:id])
  end

end
