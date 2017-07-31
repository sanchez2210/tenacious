class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_and_belongs_to_many :organizations
  has_many :inventory_users
  has_many :inventories, through: :inventory_users
  has_many :owned_inventories, class_name: 'Inventory', as: :owner
  has_many :owned_organizations, class_name: 'Organization', foreign_key: 'owner_id'
end
