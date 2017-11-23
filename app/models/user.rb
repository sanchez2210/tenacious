class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }

  has_and_belongs_to_many :organizations

  has_many :inventory_users

  has_many :confirmed_inventory_users,
           -> { confirmed },
           class_name: 'InventoryUser'

  has_many :pending_inventory_users,
           -> { pending },
           class_name: 'InventoryUser'

  has_many :inventories, through: :inventory_users

  has_many :confirmed_inventories,
           source: :inventory,
           through: :confirmed_inventory_users

  has_many :pending_inventories,
           source: :inventory,
           through: :pending_inventory_users

  has_many :owned_inventories,
           class_name: 'Inventory',
           as: :owner

  has_many :owned_organizations, class_name: 'Organization', foreign_key: 'owner_id'

  def self.search(query)
    where('username ilike :q or email ilike :q', q: "%#{query}%").limit(5)
  end

  def inventory_access?(user_role, inventory)
    permission = 'admin' if inventory.admins.include?(self)
    permission = 'write' if inventory.writers.include?(self)
    permission = 'read' if inventory.readers.include?(self)

    return if permission.nil? || InventoryUser.user_roles[permission] < InventoryUser.user_roles[user_role]
    true
  end

  def inventory_user_for(inventory)
    inventory_users.confirmed.where(inventory: inventory).first
  end
end
