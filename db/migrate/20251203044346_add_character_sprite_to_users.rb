class AddCharacterSpriteToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :character_sprite, :string
  end
end
