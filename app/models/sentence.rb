class Sentence < ApplicationRecord
  belongs_to :review
  has_many :sentence_entities
  has_many :entities, through: :sentence_entities
end
