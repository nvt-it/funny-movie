# == Schema Information
#
# Table name: votes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  movie_id   :bigint           not null
#  vote_type  :integer          default("up"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class MovieTest < ActiveSupport::TestCase
  fixtures :users, :movies, :votes

  test 'should not save vote without user' do
    vote = votes(:vote1)
    vote.user_id = nil

    assert_not vote.save
    assert_equal "User must exist", vote.error_message
  end

  test 'should not save vote when user was not existed' do
    vote = votes(:vote1)
    vote.user_id = 99

    assert_not vote.save
    assert_equal "User must exist", vote.error_message
  end

  test 'should not save vote without movie' do
    vote = votes(:vote1)
    vote.movie_id = nil

    assert_not vote.save
    assert_equal "Movie must exist", vote.error_message
  end

  test 'should not save vote when movie was not existed' do
    vote = votes(:vote1)
    vote.movie_id = 99

    assert_not vote.save
    assert_equal "Movie must exist", vote.error_message
  end

  test 'should increase vote_ups_count when user voted up movie' do
    movie1 = movies(:movie1)
    user = users(:user2)
    expect_value = movie1.vote_ups_count + 1

    vote = user.votes.new(movie_id: movie1.id, vote_type: 'up')
    assert_equal true, vote.save

    movie1.reload
    assert_equal expect_value, movie1.vote_ups_count
  end

  test 'should increase vote_downs_count when user voted down movie' do
    movie1 = movies(:movie1)
    user = users(:user2)
    expect_value = movie1.vote_downs_count + 1

    vote = user.votes.new(movie_id: movie1.id, vote_type: 'down')
    assert_equal true, vote.save

    movie1.reload

    assert_equal expect_value, movie1.vote_downs_count
  end

  test 'shoud not save vote when user voted same movie' do
    movie1 = movies(:movie1)
    user = users(:user1)
    vote = user.votes.new(movie_id: movie1.id, vote_type: 'down')

    assert_not vote.save
    assert_equal 'Movie has been voted', vote.error_message
  end
end
