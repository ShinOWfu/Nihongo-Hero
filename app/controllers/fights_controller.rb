class FightsController < ApplicationController
  def show
    @fight = Fight.find(params[:id])
  end

  def create
    @fight = Fight.create(user: current_user, status: 'active')

    if @fight.save
      redirect_to fight_path(@fight)
    else
      flash[:alert] = @fight.errors.full_messages.join(", ")
      redirect_to map_path
    end
  end

  private

  def fight_params
  end
end
