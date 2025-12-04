class AddDefaultValuesToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :experience_points, from: nil, to: 0
    change_column_default :users, :level, from: nil, to: 0
    change_column_default :users, :hitpoints, from: nil, to: 60
  end
end
