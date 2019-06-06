# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# require 'csv'

# puts "Cleaning up database..."
# [SentenceEntity, Sentence, Review, Project, User, Entity].each(&:destroy_all)
# puts "----------------------"

# USERS = [
#   {
#     email: 'ggz@gmail.com',
#     password: '123456',
#     first_name: 'Gabriel',
#     last_name: 'GZ',
#   }
# ]

# puts "Seeding users..."
# User.create!(USERS)
# puts "Seeded #{User.count} user(s)."

# PROJECTS = [
#   {
#     user: User.first,
#     # user_id wouldn't take user instanece here
#     reviews_csv: 'fakest_url_path_ever'
#   }
# ]

# puts "Seeding projects..."
# Project.create!(PROJECTS)
# puts "Seeded #{Project.count} project(s)."

# # ---------------------------------------
# # Parse CSV and Creating REVIEW instances
# csv_text = File.read(Rails.root.join('db', 'seeds', 'sample_25_reviews.csv'))
# csv = CSV.parse(csv_text, headers:true, :encoding => 'ISO-8859-1', :row_sep => :auto, :col_sep => ";")
# csv.each do |row|
#   r = Review.new
#   r.listing_id = row['listing_id']
#   r.date = row['date']
#   r.reviewer_id = row['reviewer_id']
#   r.reviewer_name = row['reviewer_name']
#   r.comments = row['comments']
#   r.project = Project.first
#   r.save
# end

# puts "Seeding reviews..."
# puts "There are now #{Review.count} rows in the reviews table"

# # Initializing Sentimental Gem
# analyzer = Sentimental.new
# analyzer.load_defaults
# analyzer.threshold = 0.1

# @reviews = Review.all

# # ---------------------------------------
# # Creating SENTENCE instances
# @reviews.each do |r|
#   r.comments.split(".").each do |sentence|
#     s = Sentence.create(review_id: r.id,
#                         content: sentence)
#     s.update(sentiment_symbol: (analyzer.sentiment s.content),
#              sentiment_score: (analyzer.score s.content))
#   end
# end

# puts "Seeding sentences..."
# puts "Seeded #{Sentence.count} sentence(s)."

# @sentences = Sentence.all

# # Creating stop words array
# @stop_words = []
# File.open('db/stop_words.txt', "r").reduce([]) do |stop_words, line|
#   @stop_words << line.chomp
# end

# # ---------------------------------------
# # Creating ENTITY and SENTENCE_ENTITIES instances
# @sentences.each do |sentence|
#   sentence.content.chomp.downcase.split.each do |word|
#     unless @stop_words.include? word
#       if word[-1] == "!" then word.chomp!("!") end
#       entity = Entity.find_by name:word
#       if entity
#         SentenceEntity.create(sentence_id: sentence.id,
#                               entity_id: entity.id)
#       else
#         new_entity = Entity.create(name: word)
#         SentenceEntity.create(sentence_id: sentence.id,
#                               entity_id: new_entity.id)
#       end
#     end
#   end
# end

# puts "Seeding entities & sentence entities..."
# puts "Seeded #{Entity.count} entities."
# puts "Seeded #{SentenceEntity.count} sentence entities."


# puts "Cleaning up database..."
# [SentenceEntity, Sentence, Review, Project, Entity].each(&:destroy_all)
# puts "----------------------"















