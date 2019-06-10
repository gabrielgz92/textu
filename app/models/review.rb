class Review < ApplicationRecord
  belongs_to :project
  has_many :sentences
  has_many :sentence_entities
  has_many :entities, through: :sentence_entities

  # def self.best_review
  #   scores = {}
  #   Review.all.each do |reviews|
  #     reviews.sentences.each do |sentence|
  #       scores << sentence.sentiment_score
  #     end
  #   end
  #   p scores
  # end
  def sentences_count
    sentences.count
  end

  def avg_sentiment
    (sentences.pluck(:sentiment_score).reduce(&:+) / sentences_count).round(2)
  end
end
