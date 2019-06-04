# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

puts "Cleaning up database..."
[Sentence, Review, Project, User].each(&:destroy_all)
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
    user_id: User.first,
    reviews_csv: 'fakest_url_path_ever'
  }
]

puts "Seeding projects..."
Project.create!(PROJECTS)
puts "Seeded #{Project.count} project(s)."

csv_text = File.read(Rails.root.join('db', 'seeds', 'sample_25_reviews.csv'))
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

puts "Seeding sentences..."
puts "Seeded #{Sentence.count} sentence(s)."





# analyzer.sentiment "#{content}"


