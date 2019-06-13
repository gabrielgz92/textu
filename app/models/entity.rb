class Entity < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_entity_name,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }

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
    reviews.select('date', 'listing_id', 'comments')
  end

  def sentiment_over_time
    # average_sentiment, date_created
    sentiment_scores = {}
    reviews = self.reviews.includes(:sentences)
    reviews.each do |review|
      # compute sentiment score from occurences of entity within sentences
      sentences = review.sentences
      # pluck out sentences with the entity inside them
      sentiment_scores[review.date] = Entity.average_sentence_score(sentences, self)
      # sentiment_scores << [review.date, average_sentiment]
    end
    sentiment_scores
  end

  def self.average_sentence_score(sentences, word)
    occurences = sentences.select { |sentence| sentence.content.include? word.name }
    occurences.pluck(:sentiment_score).reduce(&:+) / occurences.count
  end

  # highest/lowest with averages

  def self.top_highest_sentiment_with_avgs_for_project(project_id)
    Project.includes(entities: [:sentence_entities, :sentences]).find(project_id).entities.sort_by(&:avg_sentiment).reverse!.first(5)
  end

  def self.top_lowest_sentiment_with_avgs_for_project(project_id)
    Project.includes(entities: [:sentence_entities, :sentences]).find(project_id).entities.sort_by(&:avg_sentiment).first(5)
  end
end
