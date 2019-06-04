class AddReviewToSentences < ActiveRecord::Migration[5.2]
  def change
    add_reference :sentences, :review, foreign_key: true
  end
end
