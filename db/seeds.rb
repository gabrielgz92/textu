# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

puts "Cleaning up database..."
[SentenceEntity, Sentence, Review, Project, User, Entity].each(&:destroy_all)
puts "----------------------"

USERS = [
  {
    email: 'ggz@gmail.com',
    password: '123456',
    first_name: 'Gabriel',
    last_name: 'GZ',
  }
]

puts "Seeding users..."
User.create!(USERS)
puts "Seeded #{User.count} user(s)."

PROJECTS = [
  {
    user: User.first,
    # user_id wouldn't take user instanece here
    reviews_csv: 'fakest_url_path_ever'
  }
]

puts "Seeding projects..."
Project.create!(PROJECTS)
puts "Seeded #{Project.count} project(s)."

csv_text = File.read(Rails.root.join('db', 'seeds', 'sample_3_reviews.csv'))
csv = CSV.parse(csv_text, headers:true, :encoding => 'ISO-8859-1', :row_sep => :auto, :col_sep => ";")
csv.each do |row|
  r = Review.new
  r.listing_id = row['listing_id']
  r.date = row['date']
  r.reviewer_id = row['reviewer_id']
  r.reviewer_name = row['reviewer_name']
  r.comments = row['comments']
  r.project = Project.first
  r.save
end

puts "Seeding reviews..."
puts "There are now #{Review.count} rows in the reviews table"

analyzer = Sentimental.new
analyzer.load_defaults
analyzer.threshold = 0.1

first_sentence = Sentence.create(review_id: Review.first[:id],
                           content: Review.first.comments.split(".").first
                          )
first_sentence.update(sentiment_symbol: (analyzer.sentiment first_sentence.content),
                sentiment_score: (analyzer.score first_sentence.content)
                )

second_sentence = Sentence.create(review_id: Review.second[:id],
                           content: Review.second.comments.split(".").first
                          )
second_sentence.update(sentiment_symbol: (analyzer.sentiment second_sentence.content),
                sentiment_score: (analyzer.score second_sentence.content)
                )

last_sentence = Sentence.create(review_id: Review.last[:id],
                                content: Review.last.comments.split(".").first
                                )
last_sentence.update(sentiment_symbol: (analyzer.sentiment last_sentence.content),
                     sentiment_score: (analyzer.score last_sentence.content)
                     )


puts "Seeding sentences..."
puts "Seeded #{Sentence.count} sentence(s)."

entities = Sentence.first.content.split
entities.each do |entity|
  e = Entity.find_by name:entity
  if e
    se = SentenceEntity.new
    se.sentence_id = Sentence.first[:id]
    se.entity_id = e[:id]
    se.save
  else
    newentity = Entity.new
    newentity.name = entity
    newentity.save
    se = SentenceEntity.new
    se.sentence_id = Sentence.first[:id]
    se.entity_id = newentity[:id]
    se.save
  end
end

second_entities = Sentence.second.content.split
second_entities.each do |entity|
  e = Entity.find_by name:entity
  if e
    se = SentenceEntity.new
    se.sentence_id = Sentence.second[:id]
    se.entity_id = e[:id]
    se.save
  else
    newentity = Entity.new
    newentity.name = entity
    newentity.save
    se = SentenceEntity.new
    se.sentence_id = Sentence.second[:id]
    se.entity_id = newentity[:id]
    se.save
  end
end

last_entities = Sentence.last.content.split
last_entities.each do |entity|
  e = Entity.find_by name:entity
  if e
    se = SentenceEntity.new
    se.sentence_id = Sentence.last[:id]
    se.entity_id = e[:id]
    se.save
  else
    newentity = Entity.new
    newentity.name = entity
    newentity.save
    se = SentenceEntity.new
    se.sentence_id = Sentence.last[:id]
    se.entity_id = newentity[:id]
    se.save
  end
end



puts "Seeding entities & sentence entities..."
puts "Seeded #{Entity.count} entities."
puts "Seeded #{SentenceEntity.count} sentence entities."





