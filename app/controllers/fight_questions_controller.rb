class FightQuestionsController < ApplicationController

  def index
    @fight = Fight.find(params[:id])
    @fight_questions = @fight.fight_questions
  end


  private

  def question_params
    params.require(:question).permit(:difficulty, :anwers)
  end

end
