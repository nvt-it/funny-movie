# == Schema Information
#
# Table name: movies
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  title            :string           not null
#  description      :text
#  thumb_url        :string           not null
#  video_id         :string           not null
#  vote_downs_count :bigint           default(0), not null
#  vote_ups_count   :bigint           default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "test_helper"

class MovieTest < ActiveSupport::TestCase
  fixtures :users, :movies, :votes

  test 'should not save movie without title' do
    movie = movies(:movie1)
    movie.title = nil

    assert_not movie.save
    assert_equal "Title can't be blank", movie.error_message
  end

  test 'should not save movie without user_id' do
    movie = movies(:movie1)
    movie.user_id = nil

    assert_not movie.save
    assert_equal "User must exist", movie.error_message
  end

  test 'should not save movie when user was not existed' do
    movie = movies(:movie1)
    movie.user_id = 99

    assert_not movie.save
    assert_equal "User must exist", movie.error_message
  end

  test 'should not save movie without video_id' do
    movie = movies(:movie1)
    movie.video_id = nil

    assert_not movie.save
    assert_equal "Video can't be blank", movie.error_message
  end

  test 'should not save movie without thumb_url' do
    movie = movies(:movie1)
    movie.thumb_url = nil

    assert_not movie.save
    assert_equal "Thumb url can't be blank", movie.error_message
  end

  test 'should not save movie when video_id was taken' do
    movie1 = movies(:movie1)
    movie = Movie.new(movie1.attributes.except('id'))

    assert_not movie.save
    assert_equal "Video has already been taken", movie.error_message
  end

  test 'method is_voted_by? should return true when user1 voted movie1 and false when check with user2' do
    movie = movies(:movie1)
    user = users(:user1)
    user2 = users(:user2)

    assert_equal true, movie.is_voted_by?(user.id)
    assert_equal false, movie.is_voted_by?(nil)
    assert_equal false, movie.is_voted_by?(user2.id)
  end

  test 'should save new movie when valid data' do
    user = users(:user2)
    expect_movie_size = user.movies.size + 1

    movie = user.movies.new(
      title: "#260. Gi??p ????? gia ????nh Nh?? b??? s???t l???, cu???c s???ng t??? nhi??n",
      description: "Do m??a l???n nh???ng ng??y qua, t??nh tr???ng s???t l??? ?????t ??? v??ng n??i di???n ra th?????ng xuy??n, th???t kh??ng may gia ????nh Nh?? l?? m???t trong s??? gia ????nh b??? ?????t s???t l??? l??m h?? h...",
      thumb_url: "https://i.ytimg.com/vi/nmQB4Nqv6U4/mqdefault.jpg",
      video_id: "nmQB4Nqv6U5"
    )

    assert movie.valid?
    assert movie.save
    assert_equal expect_movie_size, user.movies.size
  end

  test 'check association data' do
    movie = movies(:movie1)
    user = users(:user1)

    assert_equal user.id, movie.user.id
    assert_equal 1, movie.votes.size
  end
end
