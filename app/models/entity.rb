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
    sentence_entities.count
  end

  # def self.sentiment_over_time
  #   # average_sentiment, date_created
  #   sentiment_scores = []
  #   entity = Entity.find_by(name: "location")
  #   reviews = entity.reviews
  #   reviews.each do |review|
  #     # compute sentiment score from occurences of entity within sentences
  #     sentences = review.sentences
  #     # pluck out sentences with the entity inside them
  #     occurences = sentences.select { |sentence| sentence.content.include? "location" }
  #     average_sentiment = occurences.pluck(:sentiment_score).reduce(&:+) / occurences.count
  #     sentiment_scores << { date_created: review.date, average_sentiment: average_sentiment }
  #   # sentiment_scores << [review.date, average_sentiment]
  #   binding.pry
  #     sentiment_scores
  #   end
  # end

  def sentiment_over_time
    # average_sentiment, date_created
    sentiment_scores = {}
    reviews = self.reviews
    reviews.each do |review|
      # compute sentiment score from occurences of entity within sentences
      sentences = review.sentences
      # pluck out sentences with the entity inside them
      occurences = sentences.select { |sentence| sentence.content.include? name }
      average_sentiment = occurences.pluck(:sentiment_score).reduce(&:+) / occurences.count
      sentiment_scores[review.date] = average_sentiment
      # sentiment_scores << [review.date, average_sentiment]
    end
    sentiment_scores
  end

  def self.top_highest_sentiment
    Entity.all.sort_by(&:avg_sentiment).reverse!.map { |x| [x.name, x.occurrences] }.first(10)
  end

  def top_highest_sentiment_with_sentiment
    Entity.all.sort_by(&:avg_sentiment).reverse!.map { |x| [x.name, x.occurrences, x.avg_sentiment] }.first(10)
  end

  def self.top_lowest_sentiment
    Entity.all.sort_by(&:avg_sentiment).map { |x| [x.name, x.occurrences] }.first(10)
  end

  def self.top_lowest_sentiment_with_sentiment
    Entity.all.sort_by(&:avg_sentiment).map { |x| [x.name, x.occurrences] }.first(10)
  end
end



















