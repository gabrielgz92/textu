class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    render layout: "application_without_navbar"
  end
end
