class Friend < ApplicationRecord
  class Friend < ApplicationRecord
  # The User who created the friendship record
  belongs_to :user, class_name: 'User'

  # The User who is the friend in the relationship
  belongs_to :friend_user, class_name: 'User', foreign_key: 'friend_user_id'
  end
end