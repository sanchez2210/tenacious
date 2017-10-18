# frozen_string_literal: true

class InventoryPolicy < ApplicationPolicy
  alias inventory record

  def create?
    user
  end

  def destroy?
    admin?
  end

  def update?
    admin?
  end

  def show?
    user && user.inventory_user_for(inventory)
  end

  private

  def admin?
    return false unless user
    inventory_user = user.inventory_user_for(inventory)

    inventory_user && inventory_user.role_level >= 3
  end
end
