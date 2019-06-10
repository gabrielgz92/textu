class Entity < ApplicationRecord
  has_many :sentence_entities
  has_many :sentences, through: :sentence_entities
  has_many :reviews, through: :sentences
  # no we could retrieve reviews with entity instances
  # e.g. Entity.find(2).reviews

  # but need another method to retrieve reviews from "specific project"

  def avg_sentiment
    sentences.pluck(:sentiment_score).reduce(&:+) / occurrences
  end

  def occurrences
    sentence_entities.size
  end

  def reviews_for_entity
    {review_date: reviews.pluck(:date), listing_id: reviews.pluck(:listing_id), review: reviews.pluck(:comments)}
  end

  def sentiment_over_time
    # average_sentiment, date_created
    sentiment_scores = {}
    reviews = self.reviews.includes(:sentences)
    reviews.each do |review|
      # compute sentiment score from occurences of entity within sentences
      sentences = review.sentences
      # pluck out sentences with the entity inside them
      occurences = sentences.select { |sentence| sentence.content.include? self.name }
      average_sentiment = occurences.pluck(:sentiment_score).reduce(&:+) / occurences.count
      sentiment_scores[review.date] = average_sentiment
      # sentiment_scores << [review.date, average_sentiment]
    end
    sentiment_scores
  end

  def self.top_highest_sentiment_for_project(project_id)
    Project.find(project_id).entities.sort_by(&:avg_sentiment).reverse!.map { |x| [x.name, x.occurrences] }.first(5)
  end

  def self.top_highest_sentiment_with_avgs_for_project(project_id)
    Project.find(project_id).entities.sort_by(&:avg_sentiment).reverse!.map { |x| [x.name, x.avg_sentiment] }.first(5)
  end

  def self.top_lowest_sentiment_for_project(project_id)
    Project.find(project_id).entities.sort_by(&:avg_sentiment).map { |x| [x.name, x.occurrences] }.first(5)
  end

  def self.top_lowest_sentiment_with_avgs_for_project(project_id)
    Project.find(project_id).entities.sort_by(&:avg_sentiment).map { |x| [x.name, x.avg_sentiment] }.first(5)
  end
end















