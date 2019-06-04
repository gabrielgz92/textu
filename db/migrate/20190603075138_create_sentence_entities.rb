class CreateSentenceEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :sentence_entities do |t|
      t.references :sentence, foreign_key: true
      t.references :entity, foreign_key: true

      t.timestamps
    end
  end
end
