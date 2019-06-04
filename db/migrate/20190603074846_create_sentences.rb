class CreateSentences < ActiveRecord::Migration[5.2]
  def change
    create_table :sentences do |t|
      t.integer :review_id
      t.text :content
      t.float :sentiment_score
      t.string :sentiment_symbol

      t.timestamps
    end
  end
end
