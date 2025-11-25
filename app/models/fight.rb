class Fight < ApplicationRecord
  belongs_to :user
  belongs_to :enemy
  belongs_to :story_level
  has_many :fight_questions, dependent: :destroy
end
