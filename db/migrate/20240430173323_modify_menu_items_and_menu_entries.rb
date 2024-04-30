class ModifyMenuItemsAndMenuEntries < ActiveRecord::Migration[7.1]
  def change
    remove_column :menu_items, :price, :decimal
    add_column :menu_entries, :price, :decimal, precision: 10, scale: 2
  end
end
