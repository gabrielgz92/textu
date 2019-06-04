class Entity < ApplicationRecord
  has_many :sentence_entities
  has_many :sentences, through: :sentence_entities
  has_many :reviews, through: :sentences
  # no we could retrieve reviews with entity instances
  # e.g. Entity.find(2).reviews
end
