class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :type
      t.string :question
      t.jsonb :answers
      t.integer :correct_index
      t.string :difficulty
      
      t.timestamps
    end
  end
end
