class PatternsController < ApplicationController
  before_filter :find_pattern, only: [:edit, :show, :update, :destroy]

  def new
    @pattern = Pattern.new
  end

#  def create
#    @pattern = @code.patterns.build(params[:pattern])
#    if @pattern.save
#      flash[:notice] = "Pattern has been created"
#      redirect_to [@code, @pattern]
#    else
#      flash[:alert] = "Pattern has not been created"
#      render action: "new"
#    end
#  end

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
