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

    #Check answer and do calculate damage
    if @fight_question.selected_index.to_i == @question.correct_index
      @fight.enemy_hitpoints -= 100
      flash[:notice] = "正解！ 敵に10ダメージ！"
    else
      @fight.player_hitpoints -= 100
      flash[:alert] = "不正解！ ダメージを受けた！"
    end

    #Fight over?
    if @fight.player_hitpoints <= 0
      @fight.status = 'active'
      flash[:alert] = "敗北...体力が0になった。"
      redirect_to fight_fight_questions_path(@fight)
    elsif @fight.enemy_hitpoints <= 0
      @fight.status = 'completed'
      flash[:notice] = "勝利！敵を倒した！"
      redirect_to fight_fight_questions_path(@fight)
    else
      redirect_to fight_path(@fight)
    end
    @fight.save
  end

  def index
    @fight = Fight.find(params[:fight_id])
    @user = current_user

    # Get all fight questions for this fight
    @fight_questions = @fight.fight_questions.all

    # Calculate stats
    # correct_count = @fight_questions.count { |fq| fq.selected_index == fq.question.correct_index }
    # @correct_percentage = (@fight_questions.count > 0) ? (correct_count.to_f / @fight_questions.count * 100).round : 0

    # Determine XP player won based on status
    # @xp_gained = @fight.status == 'completed' ? 50 : 10

    # Update user's experience points and level

  end

  private

  def fight_question_params
    params.require(:fight_question).permit(:selected_index)
  end
end
