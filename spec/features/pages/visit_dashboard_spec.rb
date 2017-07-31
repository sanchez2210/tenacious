require 'rails_helper'
require 'features/feature_helpers'
include FeatureHelpers

RSpec.feature 'Visiting dashboard route' do
  let(:user) { FactoryGirl.create(:user, :confirmed) }
  let(:organization) { FactoryGirl.create(:organization, users: [user]) }
  let!(:organization_inventory) { FactoryGirl.create(:inventory, owner: organization, users: [user]) }
  let!(:user_inventory) { FactoryGirl.create(:inventory, owner: user, users: [user]) }

  feature 'as a logged in user' do
    before do
      login_as(user)
      visit dashboard_path
    end

    scenario 'shows organizations the user belongs to' do
      expect(page).to have_content(organization.name)
      expect(page).to have_link(organization.name, href: organization_path(organization))
    end

    scenario 'shows inventories the user belongs to in an organization' do
      expect(page).to have_link("#{organization.name} / #{organization_inventory.name}",
                                href: organization_inventory_path(organization, organization_inventory))
    end

    scenario 'shows inventories the user belongs to the user owns' do
      expect(page).to have_link(user_inventory.name, href: user_inventory_path(user, user_inventory))
    end
  end

  feature 'as a guest' do
    before do
      visit dashboard_path
    end

    will_redirect_to_login_page
  end
end
