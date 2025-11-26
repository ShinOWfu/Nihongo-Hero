class FightQuestionsController < ApplicationController
  def create
    @fight = Fight.find(params[:id])
    question_type = params[:question_type]

    if question_type == random
      @question = Question.all.sample
    else
      @question = Question.where(question_type: question_type).all.sample
    end

    FightQuestion.create(fight: @fight, question: @question)

  end

end
