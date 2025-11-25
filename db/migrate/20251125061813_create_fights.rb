class CreateFights < ActiveRecord::Migration[7.1]
  def change
    create_table :fights do |t|
      t.string :status
      t.integer :enemy_hitpoints
      t.integer :player_hitpoints
      t.references :user, null: false, foreign_key: true
      t.references :enemy, null: false, foreign_key: true
      t.references :story_level, null: false, foreign_key: true
      t.timestamps
    end
  end
end
