class FightQuestionsController < ApplicationController
  def create
    @fight = Fight.find(params[:fight_id])
    question_type = params[:question_type]
    used_question_ids = FightQuestion.pluck(:question_id).uniq

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
      @damage_received = 10
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
