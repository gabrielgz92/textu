class SentenceEntity < ApplicationRecord
  belongs_to :sentence
  belongs_to :entity
end
