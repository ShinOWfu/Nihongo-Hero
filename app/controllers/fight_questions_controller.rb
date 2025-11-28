class FightQuestionsController < ApplicationController
  def create
    @fight = Fight.find(params[:fight_id])
    question_type = params[:question_type]
    used_question_ids = FightQuestion.pluck(:question_id).uniq

    if question_type == "random"
      @question = Question.all.where.not(id: used_question_ids).sample
    else
      @question = Question.where(question_type: question_type).where.not(id: used_question_ids).all.sample
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
      @damage_dealt = 5
      @fight.enemy_hitpoints -= @damage_dealt
      flash[:notice] = "正解！ 敵に#{@damage_dealt}ダメージ！"
    else
      @damage_received = 50
      @fight.player_hitpoints -= @damage_received
      flash[:alert] = "不正解！ #{@damage_received}ダメージを受けた！"
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

  # Implement xp earning calculation & level up the user
  def index
    @fight = Fight.find(params[:fight_id])
    @user = current_user

    # Get all fight questions for this fight
    @fight_questions = @fight.fight_questions.all

    #Update level and experience points
    experience_points
    #Calculate the percentage of correct questions
    @percentage_correct = percentage_correct
    raise
  end

  def experience_points
    @current_exp = @user.experience_points
    # Allocate exp points after the fight, based on enemy hp. Maybe change this later to make more sophisticated
    @fight.status == "complete" ? @exp_gained = @fight.enemy.hitpoints : @exp_gained = 0
    # Check for player level up. Assuming each level requires 100 exp. Make better later
    if @current_exp + @exp_gained / 100 != current_user.level
      @level_up = true
      @current_exp = @current_exp + @exp_gained
      current_user.level = @current_exp / 100
    else
      @level_up = false
    end
  end

  def percentage_correct
    all_count = @fight.fight_questions.all.count
    correct_count = @fight.fight_questions.where(:selected_index == @question.correct_index).count
    return percentage_correct = all_count/correct_count
  end
  private

  def fight_question_params
    params.require(:fight_question).permit(:selected_index)
  end
end
