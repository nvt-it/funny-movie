require "test_helper"

class SessionWorkflowTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    @one = movies(:movie1)
    @two = movies(:movie2)
  end

  test 'home page' do
    visit root_path

    assert page.has_content?(@one.title)
    assert page.has_content?(@two.title)

    assert_button 'Login / Register'
    assert_field 'user[email]', type: 'email'
    assert_field 'user[password]', type: 'password'
    assert_selector 'i', class: 'fa fa-thumbs-o-up fa-2x'
    assert_selector 'i', class: 'fa fa-thumbs-o-down fa-2x'
    assert_selector 'div', class: 'movie-vote-result'
  end

  test 'submit when missing email' do
    visit root_path

    fill_in 'user[password]', with: '12345678'
    click_on 'Login / Register'

    assert page.has_content?("Email can't be blank")
  end

  test 'submit when missing password' do
    visit root_path

    fill_in 'user[email]', with: 'abc@example.com'
    click_on 'Login / Register'

    assert page.has_content?("Password can't be blank")
  end

  test 'submit with wrong password' do
    visit root_path
    user = users(:user1)

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: '123456'
    click_on 'Login / Register'

    assert page.has_content?("Invalid Email or password.")
  end

  test 'submit success with correct account' do
    user = users(:user1)

    login(user)

    assert page.has_content?("Signed in successful")
    assert page.has_content?("Welcome #{user.email}")

    assert_selector 'a', class: 'header-button link-button', text: 'Logout'
    assert_selector 'a', class: 'header-button link-button', text: 'Share a movie'
  end
end
