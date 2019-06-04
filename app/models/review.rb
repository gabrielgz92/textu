class Review < ApplicationRecord
  belongs_to :project
  has_many :sentences
end
