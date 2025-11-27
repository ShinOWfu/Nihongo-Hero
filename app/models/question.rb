class Question < ApplicationRecord
  has_many :fight_questions, dependent: :destroy
end
