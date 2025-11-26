class AddJapaneseDifficultyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :japanese_difficulty, :integer
  end
end
