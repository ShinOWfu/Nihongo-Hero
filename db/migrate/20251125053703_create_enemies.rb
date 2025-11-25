class CreateEnemies < ActiveRecord::Migration[7.1]
  def change
    create_table :enemies do |t|
      t.integer :hitpoints
      t.string :name
      t.string :sprite

      t.timestamps
    end
  end
end
