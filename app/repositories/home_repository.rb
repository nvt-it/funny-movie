class HomeRepository < BaseRepository
  def initialize
    super
  end

  def movies(params)
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    Movie.page(page).per(per_page)
  end
end