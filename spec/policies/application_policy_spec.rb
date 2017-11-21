# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { ApplicationPolicy.new(user, model) }
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:model) { nil }

  describe 'default values' do
    [:show?, :edit?, :update?, :destroy?, :new?, :create?, :index?].each do |action|
      it "does not permit the #{action} action" do
        expect(subject.send(action)).to be_falsey
      end
    end
  end

  describe '#scope' do
    let(:model) { Inventory.new }

    it 'returns a sane default policy scope for `record`' do
      expect(subject.scope).to eq Inventory
    end
  end
end
