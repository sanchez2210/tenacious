class AddPolymorphicOwnerIdToInventories < ActiveRecord::Migration[5.1]
  def change
    add_column :inventories, :owner_id, :integer, null: false
    add_column :inventories, :owner_type, :string, null: false
    add_index :inventories, [:owner_id, :owner_type]
  end
end
