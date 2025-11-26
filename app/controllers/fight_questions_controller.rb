class FightQuestionsController < ApplicationController
  def create
    #Create a question when picking one of the attack options on the fight screen. Get the fight from the params
    @fight_question = FightQuestion.create(fight: Fight.find(params[:fight_id]))
    #Assign a random question to the @fight_question
    used_question_ids = FightQuestion.pluck(:question_id).uniq
    @fight_question = Question.where.not(id: used_question_ids).where(type: params[:type]).sample
    
  end
end
