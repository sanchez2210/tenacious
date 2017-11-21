class InventoryUser < ApplicationRecord
  validates :user_role, presence: true

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :pending, -> { where(confirmed_at: nil) }

  belongs_to :user
  belongs_to :inventory

  enum user_role: [:read, :write, :admin]

  def role_level
    {
      read: 1,
      write: 2,
      admin: 3
    }[user_role.to_sym]
  end
end
