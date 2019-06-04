class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :listing_id
      t.string :date
      t.string :reviewer_id
      t.string :reviewer_name
      t.text :comments
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
