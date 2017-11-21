# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryPolicy do
  subject { InventoryPolicy.new(user, inventory) }
  let(:inventory) { FactoryGirl.create(:inventory) }

  context 'when user is not authenticated' do
    let(:user) { nil }
    [:new?, :create?, :show?, :edit?, :update?, :destroy?].each do |action|
      it "does not permit the #{action} action" do
        expect(subject.send(action)).to be_falsey
      end
    end
  end

  context 'when user is not an inventory member' do
    let(:user) { FactoryGirl.build(:user) }
    [:new?, :create?].each do |action|
      it "permits the #{action} action" do
        expect(subject.send(action)).to be_truthy
      end
    end

    [:show?, :edit?, :update?, :destroy?].each do |action|
      it "does not permit the #{action} action" do
        expect(subject.send(action)).to be_falsey
      end
    end
  end

  context 'when user is an inventory member with the read role' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:inventory_user) do
      InventoryUser.create!(
        user: user,
        inventory: inventory,
        user_role: :read,
        confirmed_at: Time.current
      )
    end

    [:new?, :create?, :show?].each do |action|
      it "permits the #{action} action" do
        expect(subject.send(action)).to be_truthy
      end
    end

    [:edit?, :update?, :destroy?].each do |action|
      it "does not permit the #{action} action" do
        expect(subject.send(action)).to be_falsey
      end
    end
  end

  context 'when user is an inventory member with the write role' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:inventory_user) do
      InventoryUser.create!(
        user: user,
        inventory: inventory,
        user_role: :write,
        confirmed_at: Time.current
      )
    end

    [:new?, :create?, :show?].each do |action|
      it "permits the #{action} action" do
        expect(subject.send(action)).to be_truthy
      end
    end

    [:edit?, :update?, :destroy?].each do |action|
      it "does not permit the #{action} action" do
        expect(subject.send(action)).to be_falsey
      end
    end
  end

  context 'when user is an inventory member with the admin role' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:inventory_user) do
      InventoryUser.create!(
        user: user,
        inventory: inventory,
        user_role: :admin,
        confirmed_at: Time.current
      )
    end

    [:new?, :create?, :show?, :edit?, :update?, :destroy?].each do |action|
      it "permits the #{action} action" do
        expect(subject.send(action)).to be_truthy
      end
    end
  end
end
