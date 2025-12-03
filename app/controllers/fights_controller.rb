class FightsController < ApplicationController

  def index
    @fights = current_user.fights.includes(:enemy, fight_questions: :question).order(created_at: :desc)

    @fight_stats = {}

    @fights.each do |fight|
      total = fight.fight_questions.count
      correct = fight.fight_questions.joins(:question)
                     .where('fight_questions.selected_index = questions.correct_index')
                     .count
      accuracy = total > 0 ? (correct.to_f / total * 100).to_i : 0

      rank = case accuracy
             when 100 then 'S'
             when 80..99 then 'A'
             when 60..79 then 'B'
             when 40..59 then 'C'
             when 20..39 then 'D'
             else 'F'
             end

      @fight_stats[fight.id] = {
        total: total,
        correct: correct,
        accuracy: accuracy,
        rank: rank,
        victory: fight.status == 'completed'
      }
    end
  end

  def show     #I can see a list of actions at the start of the fight (attack, ability, item, retreat)
    @fight = Fight.find(params[:id])
    @fight_questions = @fight.fight_questions
  end

  def create  
    #Oliver: Update the story level to the next higher level. If this is the first fight, start at 1
    if current_user.fights.count == 0
      @story_level = 1
    elsif current_user.fights.last.status == 'completed'
      @story_level = current_user.fights.last.story_level_id + 1
    else
      @story_level = current_user.fights.last.story_level_id
    end

    #Hardcoding the enemies for the story_level 9 and 10 fights
    if @story_level.id == 9
      enemy = Enemy.find(10)
    elsif @story_level.id == 10
      enemy = Enemy.find(9)
    else
    enemy = Enemy.all.sample
    end
    @fight = Fight.new(
      status: 'active',   #Fights are either active or completed
      user: current_user,
      enemy: enemy,
      player_hitpoints: current_user.hitpoints,
      enemy_hitpoints: enemy.hitpoints,
      story_level: StoryLevel.find(@story_level)
    )

    if @fight.save
      redirect_to fight_path(@fight)
    else
      flash[:alert] = @fight.errors.full_messages.join(", ")
      redirect_to map_path
    end
  end
end
