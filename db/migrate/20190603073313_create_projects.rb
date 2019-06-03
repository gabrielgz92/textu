class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true
      t.string :reviews_csv

      t.timestamps
    end
  end
end
