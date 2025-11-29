class FightQuestionsController < ApplicationController
  def create
    @fight = Fight.find(params[:fight_id])
    question_type = params[:question_type]
    used_question_ids = current_user.fight_questions.pluck(:question_id).uniq

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
      @damage_dealt = 50
      @fight.enemy_hitpoints -= @damage_dealt
      flash[:notice] = "正解！ 敵に#{@damage_dealt}ダメージ！"
    else
      @damage_received = 5
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

  #This needs to be changed to a custom results function since we need the index function to show all questions
  def index
    @fight = Fight.find(params[:fight_id])
    @user = current_user

    # Get all fight questions for this fight
    @fight_questions = @fight.fight_questions.all

    #Update level and experience points
    experience_points
    #Calculate the percentage of correct questions
    @percentage_correct = percentage_correct
  end

  def experience_points
    @current_exp = @user.experience_points
    # Allocate exp points after the fight, based on enemy hp. Maybe change this later to make more sophisticated
    @fight.status == "completed" ? @exp_gained = @fight.enemy.hitpoints : @exp_gained = 0
    # Check for player level up. Assuming each level requires 100 exp. Make better later
    @current_exp + @exp_gained / 100 > @user.level ? @level_up = true : @level_up = false
    # Update the user level and exp
    @user.experience_points = @current_exp + @exp_gained
    @user.level = @user.experience_points / 100 if @current_exp > 100
    @user.save    
  end

  def percentage_correct
    all_count = @fight.fight_questions.all.count
    # @question = @fight.fight_questions
    correct_count = @fight.fight_questions.joins(:question).where('fight_questions.selected_index = questions.correct_index').count
    return percentage_correct = correct_count.to_f/all_count * 100
  end
  private

  def fight_question_params
    params.require(:fight_question).permit(:selected_index)
  end
end
