class HomeController < ApplicationController
  before_action :authenticate_user!, only: :share
  before_action :load_resources

  def index
    @movies = @repo.movies(normalize_parameters)
  end

  private

  def normalize_parameters
    params.permit(:page, :per_page)
  end

  def load_resources
    case params[:action].to_sym
    when :index
      @repo = HomeRepository.new
    end
  end
end