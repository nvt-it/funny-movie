class MoviesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resources

  def new
  end

  def create
    is_success, message = repo.create(normalize_parameters)

    if is_success
      redirect_to root_path, notice: message

      return
    end

    redirect_to new_movie_path, alert: message
  end

  private

  def normalize_parameters
    params.require(:movie).permit(:url)
  end

  def repo
    MovieRepository.new(@movie)
  end

  def load_resources
    case params[:action].to_sym
    when :create
      @movie = current_user.movies.new
    end
  end
end