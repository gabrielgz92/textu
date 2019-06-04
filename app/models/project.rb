class Project < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :sentences, through: :reviews
  has_many :sentence_entities, through: :sentences
  has_many :entities, through: :sentence_entities
  # no we could retrieve entities with project instances
  # e.g. Project.find(2).entities

  # def top_five_entities
  # end
  # to get top 5 enities' instances from project instance

  # def worst_five_entities
  # end
  # to get worst 5 enities' instances from project instance
end
