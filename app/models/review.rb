class Review < ApplicationRecord
  belongs_to :project
  has_many :sentences
  has_many :sentence_entities
  has_many :entities, through: :sentence_entities
end
