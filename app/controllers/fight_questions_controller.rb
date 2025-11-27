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
      redirect_to fight_path(@fight), alert: 'Error creating questions'
    end
  end

  def show
    @fight = Fight.find(params[:fight_id])
    @fight_question = FightQuestion.find(params[:id])
    @question = @fight_question.question
  end

  def update
    @fight_question = FightQuestion.find(params[:id])
    @fight = @fight_question.fight
    @question = @fight_question.question

    @fight_question.update(selected_index: fight_question_params[:selected_index])

    if @fight_question.selected_index.to_i == @question.correct_index
      @fight.enemy_hitpoints -= 10
      flash[:notice] = "正解！ 敵に10ダメージ！"
      if @fight.enemy_hitpoints <= 0
        @fight.status = 'won!'
        flash[:notice] = "勝利！敵を倒した！"
        redirect_to map_path
      end
    else
      @fight.player_hitpoints -= 10
      flash[:alert] = "不正解！ ダメージを受けた！"
      if @fight.player_hitpoints <= 0
        @fight.status = 'lost'
        flash[:alert] = "敗北...体力が0になった。"
        redirect_to map_path
      end
    end
    @fight.save
    redirect_to fight_path(@fight)
  end

  private

  def fight_question_params
    params.require(:fight_question).permit(:selected_index)
  end
end
