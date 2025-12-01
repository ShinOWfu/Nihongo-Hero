class AddDefaultValuesToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :experience_points, from: nil, to: 0
    change_column_default :users, :level, from: nil, to: 0
    change_column_default :users, :hitpoints, from: nil, to: 100

    # Update existing users with nil values
    User.where(experience_points: nil).update_all(experience_points: 0)
    User.where(level: nil).update_all(level: 0)
    User.where(hitpoints: nil).update_all(hitpoints: 100)
  end
end
