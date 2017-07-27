require 'rails_helper'
require 'features/feature_helpers'
include FeatureHelpers

RSpec.feature 'Showing an organization' do
  let(:owner) { FactoryGirl.create(:user, :confirmed) }
  let(:member) { FactoryGirl.create(:user, :confirmed) }
  let(:organization) { FactoryGirl.create(:organization, owner: owner, users: [owner, member]) }

  feature 'as a member of the organization' do
    before do
      login_as(member)
      visit organization_path(organization)
    end

    scenario 'shows the name of the organization' do
      expect(page).to have_content(organization.name)
    end

    scenario "doesn't show a link to create a new inventory" do
      expect(page).not_to have_link('Create an Inventory')
    end
  end

  feature 'as the owner of the organization' do
    before do
      login_as(owner)
      visit organization_path(organization)
    end

    scenario 'shows a link to create a new inventory' do
      expect(page).to have_link('Create an Inventory')
    end
  end

  feature 'as a user not part of the organization' do
    before do
      user = FactoryGirl.create(:user, :confirmed)
      login_as(user)
      visit organization_path(organization)
    end

    scenario 'redirects to the root path' do
      expect(current_path).to eq(root_path)
    end

    scenario 'shows a message saying why the user was denied access' do
      expect(page).to have_content('You need to be part of this organization to view it')
    end
  end

  feature 'as a guest' do
    before do
      visit organization_path(organization)
    end

    will_redirect_to_login_page
  end
end
