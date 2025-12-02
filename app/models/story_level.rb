class StoryLevel < ApplicationRecord
  has_many :fights
  has_many :fight_questions, through: :fights
end
