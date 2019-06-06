require 'csv'

class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      # save project as reviews here when project is created
      parse_csv_into_reviews
      # creating sentences
      create_sentences_from_reviews
      # creating entities and their relation with sentences
      create_sentence_entities_and_entities_from_sentences
      # just for testing, this needs to redirect to graphs later on
      redirect_to projects_path
    else
      render :new
    end
  end

  # Important Tip
  # For reading CSV file within Project instance, use
  # project_instances.reviews_csv.file.file

  private

  def project_params
    params.require(:project).permit(:project_name, :description, :reviews_csv)
  end

  def parse_csv_into_reviews
    csv_file_path = @project.reviews_csv.file.file
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', row_sep: :auto, col_sep: ";")
    csv.each do |row|
      r = Review.new
      r.listing_id = row['listing_id']
      r.date = row['date']
      r.reviewer_id = row['reviewer_id']
      r.reviewer_name = row['reviewer_name']
      r.comments = row['comments']
      r.project = @project
      r.save
    end
  end

  def create_sentences_from_reviews
    analyzer = Sentimental.new
    analyzer.load_defaults
    analyzer.threshold = 0.1

    @reviews = @project.reviews
    @reviews.each do |r|
      r.comments.split(".").each do |sentence|
        s = Sentence.create(review_id: r.id,
                            content: sentence)
        s.update(sentiment_symbol: (analyzer.sentiment s.content),
                 sentiment_score: (analyzer.score s.content))
      end
    end
  end

  def create_sentence_entities_and_entities_from_sentences
    @stop_words = []
    File.open('db/stop_words.txt', "r").reduce([]) do |stop_words, line|
      @stop_words << line.chomp
    end

    @sentences = @project.sentences
    @sentences.each do |sentence|
      sentence.content.chomp.downcase.split.each do |word|
        unless @stop_words.include? word
          if word[-1] == "!" then word.chomp!("!") end
          entity = Entity.find_by name: word
          if entity
            SentenceEntity.create(sentence_id: sentence.id,
                                  entity_id: entity.id)
          else
            new_entity = Entity.create(name: word)
            SentenceEntity.create(sentence_id: sentence.id,
                                  entity_id: new_entity.id)
          end
        end
      end
    end
  end
end
