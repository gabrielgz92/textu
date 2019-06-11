class Review < ApplicationRecord
  belongs_to :project
  has_many :sentences
  has_many :sentence_entities
  has_many :entities, through: :sentence_entities

  def self.best_review(project_id)
    Project.find(project_id).reviews.sort_by(&:avg_sentiment).reverse!.map { |r| [r, r.avg_sentiment] }.first
  end

  def self.worst_review(project_id)
    Project.find(project_id).reviews.sort_by(&:avg_sentiment).map { |r| [r, r.avg_sentiment] }.first
  end

  def sentences_count
    sentences.count
  end

  def avg_sentiment
    (sentences.pluck(:sentiment_score).reduce(&:+) / sentences_count).round(2)
  end

  def self.total_reviews_avg_sentiment(project_id)
    scores = Project.find(project_id).reviews.first(3).map(&:avg_sentiment)
    (scores.reduce(:+) / scores.count).round(2)
  end

  def self.current_project_reviews(project_id)
    Project.find(project_id).reviews.count
  end
end
