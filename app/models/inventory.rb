class Inventory < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 255 }

  has_many :inventory_users
  has_many :users, through: :inventory_users
  belongs_to :owner, polymorphic: true
end
