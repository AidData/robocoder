class PatternsController < ApplicationController
  before_filter :find_pattern, only: [:edit, :show, :update, :destroy]

  def new
    @pattern = Pattern.new
  end

  def create
    code_nums = params["pattern"].delete("codes")
    @codes = []
    if code_nums
      code_nums.each do |num|
        num.gsub!(/\./,'')
        @codes << Code.find(num)
      end
    end
    @pattern = Pattern.new(params["pattern"])
    @pattern.codes << @codes

    respond_to do |format|
      if @pattern.save
        format.html { render @pattern, notice: "Pattern has been created" }
        format.json { render json: @pattern }
      else
        format.html {render action: 'new', alert: "Pattern has not been created" }
        format.json { render json: @pattern.errors, status: :unproccessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @pattern.update_attributes(params[:pattern])
        format.html { render @pattern, notice: 'Pattern updated successfully' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pattern.errors, status: :unproccessable_entity }
      end
    end
  end

  private

  def find_pattern
    @pattern = Pattern.find(params[:id])
  end
end
