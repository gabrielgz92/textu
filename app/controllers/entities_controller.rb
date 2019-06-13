class EntitiesController < ApplicationController
  before_action :set_project, only: %i[index show entites_data index]
  before_action :set_entities, only: %i[index reviews_for_entity]

  def index
    @entity = Entity.find_by(name: params[:entity])
    @first_word_score = first_word_score
    @last_word_score = last_word_score
    @first_month = first_month
    @last_month = last_month

    respond_to do |format|
      format.html { render layout: 'tour' }
      format.json { render json: @entity.sentiment_over_time.sort.to_h }
    end
  end

  def reviews_for_entity
    @reviews = Entity.reviews_for_entity
    render layout: 'tour'
  end

  def show
    @entity = Entity.find(params[:id])
    render layout: 'tour'
  end

  def entities_data
    # Loading the data for the scatter plot chart
    sentence_entities = SentenceEntity.joins(:entity, :sentence).includes(entity: :sentences)
    filtered_entities = sentence_entities.reject{ |sentence_entity| sentence_entity.entity.sentences.size < 7 }

    filtered_with_duplicates = filtered_entities.map { |sentence_entity| { label: sentence_entity.entity.name, data: [{x: sentence_entity.entity.sentences.size, y: sentence_entity.entity.avg_sentiment}] } }
    filtered_without_duplicates = filtered_with_duplicates.uniq { |data| data[:label] }
    @datasets = filtered_without_duplicates
    # load data for highest average sentiment score
    entitiesWithHighestSentiment = Entity.top_highest_sentiment_with_avgs_for_project(params[:project_id]);
    @firstHighest = entitiesWithHighestSentiment.first
    @secondHighest = entitiesWithHighestSentiment.second

    # load data for lowest average sentiment score
    entitiesWithLowestSentiment = Entity.top_lowest_sentiment_with_avgs_for_project(params[:project_id]);
    @firstLowest = entitiesWithLowestSentiment.first
    @secondLowest = entitiesWithLowestSentiment.second

    # 3. map the filtered data into a form that chart.js like

    render layout: 'tour'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_entities
    project_entities_object = Project.includes(entities: [:sentence_entities, :sentences]).find(params[:project_id])
    project_entities = project_entities_object.entities.group(:name).order('count_id desc').count('id').reject!{ |k, v| v == 1 }
    @entities = project_entities
    # returns a hash of entity list in descending order

  end

  def entities_params
    params.permit(:entity)
  end

  def avg_entity_symbol
    @project.sentences.pluck(:sentiment_score).reduce(&:+) / @entity.sentence_entities.count
  end

  def first_word_score
    return false if @entity.nil?

    first_word = @entity.reviews.map{|x| [x.date, x.id] }.min
    test_re = @project.reviews.find(first_word[1]).sentences.select { |sentence| sentence.content.include? @entity.name }
    test_re[0].sentiment_score
  end

  def last_word_score
    return false if @entity.nil?

      last_word = @entity.reviews.map { |x| [x.date, x.id] }.sort.last
      sentences = @project.reviews.find(last_word[1]).sentences
      Entity.average_sentence_score(sentences, @entity)
  end

  def first_month
    return false if @entity.nil?

    date = @entity.reviews.group_by_month(:date, format: "%m %Y").count.first[0].to_i
    Date::MONTHNAMES[date]
  end

  def last_month
    return false if @entity.nil?

    date = @entity.reviews.group_by_month(:date, format: "%m %Y").count.sort.reverse.first[0].to_i
    Date::MONTHNAMES[date]
  end
end
