class RemoveReviewIdFromSentences < ActiveRecord::Migration[5.2]
  def change
    remove_column :sentences, :review_id, :integer
  end
end
