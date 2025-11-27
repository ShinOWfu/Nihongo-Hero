class FightQuestionsController < ApplicationController
  def create
    @fight = Fight.find(params[:fight_id])
    question_type = params[:question_type]

    if question_type == "random"
      @question = Question.all.sample
    else
      @question = Question.where(question_type: question_type).all.sample
    end

    @fight_question = FightQuestion.new(fight: @fight, question: @question)

    if @fight_question.save
      redirect_to fight_fight_question_path(@fight, @fight_question)
    else
      redirect_to fights_path(@fight), alert: 'Error creating questions'
    end
  end

  def show
    @fight = Fight.find(params[:fight_id])
    @fight_question = FightQuestion.find(params[:id])
    @question = @fight_question.question
  end
end
