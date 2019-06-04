class Sentence < ApplicationRecord
  has_many :sentence_entity
  belongs_to :review
end
