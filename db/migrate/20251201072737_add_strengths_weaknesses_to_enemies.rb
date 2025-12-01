class AddStrengthsWeaknessesToEnemies < ActiveRecord::Migration[7.1]
  def change
    add_column :enemies, :strength, :string
    add_column :enemies, :weakness, :string
  end
end
