class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true, index: true
      
      t.references :friend_user, null: false, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
    # Ensure a user cannot add the same friend twice
    add_index :friendships, [:user_id, :friend_user_id], unique: true 
  end
end