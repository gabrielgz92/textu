class Project < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :sentences, through: :reviews
  has_many :sentence_entities, through: :sentences
  has_many :entities, through: :sentence_entities
  # no we could retrieve entities with Project instances
  # e.g. Project.find(2).entities
end
