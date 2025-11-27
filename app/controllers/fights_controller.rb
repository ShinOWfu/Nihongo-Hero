class FightsController < ApplicationController
  def show     #I can see a list of actions at the start of the fight (attack, ability, item, retreat)
    @fight = Fight.find(params[:id])
    @fight_questions = @fight.fight_questions
  end

end
