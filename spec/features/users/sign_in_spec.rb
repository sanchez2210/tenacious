require 'rails_helper'

RSpec.feature 'Users signing in' do
  let(:user) { FactoryGirl.create(:user, :confirmed) }

  before do
    visit '/'
    click_link 'Sign In'
  end

  feature 'with valid credentials' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end

    scenario 'succeeds and restricts access to the sign in route' do
      visit new_user_session_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are already signed in')
    end

    scenario 'shows a message saying the user was logged in' do
      expect(page).to have_content('Signed in successfully')
    end
  end

  shared_examples 'a failed sign in attempt' do
    scenario 'fails and stays on the sign in page' do
      expect(current_path).to eq(new_user_session_path)
      expect(page).not_to have_content('Signed in successfully')
    end

    scenario 'shows a message showing why the authenticatication was not successful' do
      expect(page).to have_content('Invalid Email or password')
    end
  end

  feature 'with invalid credentials' do
    before do
      fill_in 'Email', with: 'wrong_email@example.com'
      fill_in 'Password', with: 'wrong_password'
      click_button 'Sign in'
    end

    include_examples 'a failed sign in attempt'
  end

  feature 'with no credentials' do
    before do
      click_button 'Sign in'
    end

    include_examples 'a failed sign in attempt'
  end
end
