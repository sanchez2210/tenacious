require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe '#confirmed' do
    it 'is true in a confirmed user' do
      expect(FactoryGirl.build(:user, :confirmed).confirmed?).to be true
    end

    it 'is false in an unconfirmed user' do
      expect(FactoryGirl.build(:user).confirmed?).to be false
    end
  end

  describe '#inventories' do
    it 'returns inventories it belongs to' do
      inventories = FactoryGirl.create_list(:inventory, 2, users: [user])
      expect(user.inventories).to eq(inventories)
    end
  end

  describe '#organizations' do
    it 'returns organizations it belongs to' do
      orgs = FactoryGirl.create_list(:organization, 2, users: [user])
      expect(user.organizations).to eq(orgs)
    end
  end

  describe '#owned_organizations' do
    it 'returns organizations it owns' do
      orgs = FactoryGirl.create_list(:organization, 2, owner: user)
      expect(user.owned_organizations).to eq(orgs)
    end
  end

  describe '#owned_inventories' do
    it 'returns inventories it owns' do
      inventories = FactoryGirl.create_list(:inventory, 2, owner: user)
      expect(user.owned_inventories).to match_array(inventories.sort)
    end
  end
end
