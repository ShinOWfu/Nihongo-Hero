class CreateFightQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :fight_questions do |t|
      t.references :fight, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :selected_index

      t.timestamps
    end
  end
end
