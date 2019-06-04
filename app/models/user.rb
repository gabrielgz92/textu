class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # relations between different tables
  has_many :projects, dependent: :destroy
  has_many :reviews, through: :projects
  # retrieve reviews from User instances
  # e.g current_user.reviews
  has_many :sentences, through: :reviews
  has_many :sentence_entities, through: :sentences
  has_many :entities, through: :sentence_entities
  # retrieve entities from User instances
  # e.g current_user.entities

  # def top_five_entities
  # end
  # to get top 5 enities' instances from user instance

  # def worst_five_entities
  # end
  # to get worst 5 enities' instances from user instance
end
