class FightsController < ApplicationController

  def index
    @fights = Fight.all
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

    enemy = Enemy.all.sample
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
