class FightQuestionsController < ApplicationController
  BASE_PLAYER_DAMAGE = 50
  BASE_ENEMY_DAMAGE = 20

  def create
    @fight = Fight.find(params[:fight_id])
    question_type = params[:question_type]
    used_question_ids = current_user.fight_questions.pluck(:question_id).uniq

    # This line ensures instances are duplicated but incorrectquestionID will be removed once corrected
    latest_fight_questions = FightQuestion.where( id: FightQuestion.group(:question_id).select('MAX(id)') )
    # get all past questions answered incorrectly in THIS fight
    incorrect_question_ids = latest_fight_questions  # <- this is an array
      .select{ |fq| fq.selected_index != fq.question.correct_index }
      .map do |q|
        q.question_id
      end.uniq

    # get all past questions answered correctly in THIS fight
    correct_question_ids = latest_fight_questions   # <- this is an array
      .select{ |fq| fq.selected_index == fq.question.correct_index }
      .map do |q|
        q.question_id
      end.uniq
    
    # HARDCODING the questions for fight 9 and 10. Remove after Pitch
    if @fight.story_level.id == 9
      if @fight.fight_questions.length == 0
        @question = Question.find(19)
      else
        @question = Question.find(4)
      end
    elsif @fight.story_level.id == 10
      if @fight.fight_questions.length == 0
        @question = Question.find(19)
      elsif @fight.fight_questions.length == 1
        @question = Question.find(3)
      else
        @question = Question.find(12)
      end
    else
          # no questions at start of the fight -> generate one
          if @fight.user.fight_questions.empty?
            if question_type == "random"
              @question = Question.all.where.not(id: used_question_ids).sample
            else
              @question = Question.where(question_type: question_type).where.not(id: used_question_ids).all.sample
            end
          else
            # 1. 60% → incorrect question
            if incorrect_question_ids.any? && rand < 0.6
              if question_type == "random"
                @question = Question.find(incorrect_question_ids.sample)
              else
                @question = Question.where(id: incorrect_question_ids, question_type: question_type).sample
                @question ||= Question.where(question_type: question_type).sample
              end
              # 2. 40% → NEW first, then CORRECT
            else
              if question_type == "random"
                @question = Question.where.not(id: used_question_ids).sample
                @question ||= Question.find(correct_question_ids.sample) if correct_question_ids.any?
              else
                @question = Question.where(question_type: question_type).where.not(id: used_question_ids).sample
                @question ||= Question.where(id: correct_question_ids, question_type: question_type).sample
              end
            end
          end
    end
    # MUST DUPLICATE INSTANCE & REMOVE INCORRECT_ID FROM ARRAY
    # @fight_question = FightQuestion.find_by(fight: @fight, question: @question)
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
    @damage_multiplier = calculate_damage_multiplier
    @player_damage = BASE_PLAYER_DAMAGE * @damage_multiplier
    @enemy_damage = BASE_ENEMY_DAMAGE
  end

  def update
    @fight_question = FightQuestion.find(params[:id])
    @fight = @fight_question.fight
    @question = @fight_question.question

    @fight_question.update(selected_index: fight_question_params[:selected_index])

    # Calculate damage multiplier
    damage_multiplier = calculate_damage_multiplier

    #Check answer and do calculate damage
    if @fight_question.selected_index.to_i == @question.correct_index
      @damage_dealt = BASE_PLAYER_DAMAGE * damage_multiplier
      @fight.enemy_hitpoints -= @damage_dealt
      # flash[:notice] = "正解！ 敵に#{@damage_dealt}ダメージ！"
    else
      @damage_received = BASE_ENEMY_DAMAGE
      @fight.player_hitpoints -= @damage_received
      # flash[:alert] = "不正解！ #{@damage_received}ダメージを受けた！"
    end
    #Fight over?
    if @fight.player_hitpoints <= 0
      @fight.status = 'active'
      # flash[:alert] = "敗北...体力が0になった。"
      redirect_to fight_fight_questions_path(@fight)
    elsif @fight.enemy_hitpoints <= 0
      @fight.status = 'completed'
      # flash[:notice] = "勝利！敵を倒した！"
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
    @current_exp = @user.experience_points
    # Allocate exp points after the fight, based on enemy hp. Maybe change this later to make more sophisticated
    @fight.status == "completed" ? @exp_gained = @fight.enemy.hitpoints : @exp_gained = 0
    # Check for player level up. Assuming each level requires 100 exp. Make better later
    (@current_exp + @exp_gained) / 100 > @user.level ? @level_up = true : @level_up = false
    # Update the user level and exp
    @user.experience_points = @current_exp + @exp_gained
    @user.level = @user.experience_points / 100
    @user.save
    #Calculate the percentage of correct questions
    all_count = @fight.fight_questions.all.count
    # @question = @fight.fight_questions
    correct_count = @fight.fight_questions.joins(:question).where('fight_questions.selected_index = questions.correct_index').count
    @percentage_correct = correct_count.to_f/all_count * 100

    # @xp_in_current_level = @user.experience_points % 100
    @old_exp_percent = (@user.experience_points - @exp_gained) % 100
    @new_exp_percent = @user.experience_points % 100

    @map_completed = @fight.story_level.map_node == 10 && @fight.status == "completed"
  end


  def experience_points
    @current_exp = @user.experience_points
    # Allocate exp points after the fight, based on enemy hp. Maybe change this later to make more sophisticated
    @fight.status == "completed" ? @exp_gained = @fight.enemy.hitpoints : @exp_gained = 0
    # Check for player level up. Assuming each level requires 100 exp. Make better later
    (@current_exp + @exp_gained) / 100 > @user.level ? @level_up = true : @level_up = false
    # Update the user level and exp
    @user.experience_points = @current_exp + @exp_gained
    @user.level = @user.experience_points / 100
    @user.save
    #Calculate the percentage of correct questions
    all_count = @fight.fight_questions.all.count
    # @question = @fight.fight_questions
    correct_count = @fight.fight_questions.joins(:question).where('fight_questions.selected_index = questions.correct_index').count
    @percentage_correct = correct_count.to_f/all_count * 100

    # @xp_in_current_level = @user.experience_points % 100
    @old_exp_percent = (@user.experience_points - @exp_gained) % 100
    @new_exp_percent = @user.experience_points % 100

  end

  private

  def calculate_damage_multiplier
    if @fight.enemy.weakness == @fight_question.question.question_type
      damage_multiplier = 2
    elsif @fight.enemy.strength == @fight_question.question.question_type
      damage_multiplier = 0.5
    else
      damage_multiplier = 1
    end
    return damage_multiplier
  end

  def fight_question_params
    params.require(:fight_question).permit(:selected_index)
  end
end
