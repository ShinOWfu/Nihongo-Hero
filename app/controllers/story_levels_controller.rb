# app/controllers/story_levels_controller.rb
class StoryLevelsController < ApplicationController
  before_action :authenticate_user!

  def map
    @story_levels = StoryLevel.all

    @completed_level_ids = current_user.fights.where(status: 'completed').pluck(:story_level_id)
    if @completed_level_ids.count > 0
      @accessible_level_id = @completed_level_ids.last + 1
    else
      @accessible_level_id = 1
    end

    # Get instance of current level's story
    @current_level = StoryLevel.find_by(id: @accessible_level_id)
    @all_complete = @current_level.nil?
    @current_level ||= StoryLevel.last

    # Check if level 10 was just completed
    if @completed_level_ids.include?(10) && !session[:level_10_notified]
      flash.now[:level_10_complete] = true
      session[:level_10_notified] = true  # Prevent showing multiple times
    end

  end

end
