class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false}, length: { maximum: 255 }

  has_many :inventories
  has_many :owned_inventories, class_name: 'Inventory', as: :owner
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: 'User'
end
