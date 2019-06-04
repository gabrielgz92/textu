class Entity < ApplicationRecord
  has_many :sentence_entities
  has_many :sentences, through: :sentence_entities
  has_many :reviews, through: :sentences
  has_many :projects, through: :reviews
  has_many :users, through: :projects
  # no we could retrieve reviews with entity instances
  # e.g. Entity.find(2).reviews

  # but need another method to retrieve reviews from "specific project"
end
