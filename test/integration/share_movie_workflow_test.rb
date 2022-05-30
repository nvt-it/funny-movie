require "test_helper"

class ShareMovieWorkflowTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    @one = movies(:movie1)
    @two = movies(:movie2)
    @user = users(:user1)

    login(@user)
  end

  test 'new movie page' do
    visit new_movie_path

    assert page.has_content?('Share a Youtube movie')
    assert_field 'movie[url]', type: 'text'
    assert_button 'Share'
  end

  test 'submit new movie' do
    visit new_movie_path
    video_url = 'https://www.youtube.com/watch?v=yu5tw5Nxwzs'
    expect_movie_totals = Movie.all.size + 1

    fill_in 'movie[url]', with: video_url
    click_on 'Share'

    video = VideoInfo.new(video_url)

    assert_equal expect_movie_totals, Movie.all.size
    assert page.has_content?('Share movie successful')
    assert_selector 'h4', text: video.title
    assert_selector 'p', text: "Shared by: #{@user.email}"
  end

  test 'submit new movie with invalid url' do
    visit new_movie_path
    expect_movie_totals = Movie.all.size

    fill_in 'movie[url]', with: 'https://www.youtube.com'
    click_on 'Share'

    assert_equal expect_movie_totals, Movie.all.size
    assert page.has_content?('Shared movie failed')
  end
end
