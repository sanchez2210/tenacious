class Inventory < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 255 }

  has_many :inventory_users

  has_many :confirmed_inventory_users,
           -> { confirmed },
           class_name: 'InventoryUser'

  has_many :pending_inventory_users,
           -> { pending },
           class_name: 'InventoryUser'

  has_many :admin_inventory_users,
           -> { confirmed.admin },
           class_name: 'InventoryUser'

  has_many :write_inventory_users,
           -> { confirmed.write },
           class_name: 'InventoryUser'

  has_many :read_inventory_users,
           -> { confirmed.read },
           class_name: 'InventoryUser'

  has_many :users,   through: :inventory_users
  has_many :admins,  source: :user, through: :admin_inventory_users
  has_many :writers, source: :user, through: :write_inventory_users
  has_many :readers, source: :user, through: :read_inventory_users
  has_many :invited_users, source: :user, through: :pending_inventory_users

  belongs_to :owner, polymorphic: true
end
