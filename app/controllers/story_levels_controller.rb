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
  end
end
