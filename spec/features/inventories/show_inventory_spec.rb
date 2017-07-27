require 'rails_helper'
require 'features/feature_helpers'
include FeatureHelpers

RSpec.feature 'Showing an inventory' do
  let(:member) { FactoryGirl.create(:user, :confirmed) }
  let(:user) { FactoryGirl.create(:user, :confirmed) }
  let(:inventory) { FactoryGirl.create(:inventory, users: [member]) }

  shared_examples 'has inventory information' do
    scenario 'shows the name and description of the inventory' do
      expect(page).to have_content(inventory.name)
      expect(page).to have_content(inventory.description)
    end
  end

  feature 'as a member of the inventory' do
    before do
      login_as(member)
    end

    feature 'belonging to an organization' do
      let(:organization) { FactoryGirl.create(:organization) }
      let(:inventory) { FactoryGirl.create(:inventory, owner: organization, users: [member]) }

      before do
        visit organization_inventory_path(organization, inventory)
      end

      include_examples 'has inventory information'

      scenario 'has a link to the organization' do
        expect(page).to have_content(organization.name)
      end
    end

    feature 'belonging to a user' do
      before do
        inventory.owner = member
        visit user_inventory_path(member, inventory)
      end

      include_examples 'has inventory information'
    end
  end

  feature 'as a user not part of the inventory' do
    before do
      login_as(user)
      visit user_inventory_path(member, inventory)
    end

    scenario 'redirects to the root path' do
      expect(current_path).to eq(root_path)
    end

    scenario 'shows a message saying why the user was redirected' do
      expect(page).to have_content('You need to be part of this inventory to view it')
    end
  end

  feature 'as a guest' do
    before do
      visit user_inventory_path(user, inventory)
    end

    will_redirect_to_login_page
  end
end
