class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resources

  def create
    is_success, message = repo.vote_up(normalize_parameters)

    if is_success
      redirect_to root_path, notice: message

      return
    end

    redirect_to root_path, alert: message
  end

  def destroy
    is_success, message = repo.vote_down

    if is_success
      redirect_to root_path, notice: message

      return
    end

    redirect_to root_path, alert: message
  end

  private

  def load_resources
    case params[:action].to_sym
    when :create
      @vote = current_user.votes.new
    when :destroy
      @vote = current_user.votes.find_by(params[:id])
    end
  end

  def normalize_parameters
    params.require(:vote).permit(:movie_id, :vote_type)
  end

  def repo
    VoteRepository.new(@vote)
  end
end