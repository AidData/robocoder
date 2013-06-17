class PatternsController < ApplicationController
  before_filter :find_code
  before_filter :find_pattern, only: [:edit, :show, :update, :destroy]

  def new
    @pattern = @code.patterns.build
  end

  def create
    @pattern = @code.patterns.build(params[:pattern])
    if @pattern.save
      flash[:notice] = "Pattern has been created"
      redirect_to [@code, @pattern]
    else
      flash[:alert] = "Pattern has not been created"
      render action: "new"
    end
  end

  def show
  end

  def edit
  end

  private

  def find_code
    @code = Code.find(params[:code_id])
  end

  def find_pattern
    @pattern = @code.patterns.find(params[:id])
  end
end
