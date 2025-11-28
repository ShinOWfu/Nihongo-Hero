class SetDefaultUserHitpoints < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :hitpoints, from: nil, to: 50

    # this is to update existing users' default hp
    reversible do |dir|
      dir.up do
        User.where(hitpoints: nil).update_all(hitpoints: 50)
      end
    end
  end
end
