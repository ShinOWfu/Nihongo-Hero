class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :fights, dependent: :destroy
  has_many :fight_questions, through: :fights
  
  ####Set up the Friends table:
  # 1. Who the user has ADDED as a friend:
  # This sets up user.friendships to return the Friend records (the join table).
  has_many :friendships, class_name: 'Friendship', dependent: :destroy

  # 2. The actual User objects that the current user is friends WITH:
  has_many :friends, through: :friendships, source: :friend_user

#DELETE this, I don't think we actually need it
  # 3. Who has ADDED the user as a friend (the reverse side of the relationship)
  # has_many :inverse_friendships, class_name: 'Friendship', 
  #                       foreign_key: 'friend_user_id', 
  #                       dependent: :destroy
                                 
  # has_many :friend_of, through: :inverse_friendships, source: :user
end

