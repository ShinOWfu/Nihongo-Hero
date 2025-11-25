class CreateStoryLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :story_levels do |t|
      t.text :story_content
      t.string :map_image
      t.integer :map_node

      t.timestamps
    end
  end
end
