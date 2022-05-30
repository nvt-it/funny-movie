# == Schema Information
#
# Table name: users
#
#  id                  :bigint           unsigned, not null, primary key
#  email               :string(255)      not null
#  encrypted_password  :string(255)      not null
#  remember_created_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  fixtures :users, :movies, :votes

  test 'should not save user without email' do
    user = User.new
    user.password = '12345678'

    assert_not user.save
    assert_equal "Email can't be blank", user.error_message
  end

  test 'should not save user without password' do
    user = User.new
    user.email = 'user11@example.com'

    assert_not user.save
    assert_equal "Password can't be blank", user.error_message
  end

  test 'should not save user when email format was incorrectly' do
    user = User.new
    user.email = 'user11'

    assert_not user.save
    assert_equal "Email is invalid", user.error_message
  end

  test 'should not save user when email was taken' do
    user = User.new
    user.email = 'user1@example.com'

    assert_not user.save
    assert_equal "Email has already been taken", user.error_message
  end

  test 'should not save user when password too short or too long' do
    user = User.new
    user.email = 'user11@example.com'
    user.password = '123456'

    assert_not user.save
    assert_equal "Password is too short (minimum is 8 characters)", user.error_message

    user.password = SecureRandom.hex(15)

    assert_not user.save
    assert_equal "Password is too long (maximum is 20 characters)", user.error_message
  end

  test 'should save new user when valid data' do
    expect_total_users = User.all.size + 1
    user = User.new
    user.email = "user#{Time.current.to_i}@example.com"
    user.password = '12345678'

    assert user.valid?
    user.save

    assert_equal expect_total_users, User.all.size
  end

  test 'check association data' do
    user = users(:user1)

    assert_equal 2, user.movies.size
    assert_equal 1, user.votes.size
  end
end
