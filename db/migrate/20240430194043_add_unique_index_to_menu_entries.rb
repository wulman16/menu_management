class AddUniqueIndexToMenuEntries < ActiveRecord::Migration[7.1]
  def change
    add_index :menu_entries, %i[menu_id menu_item_id], unique: true
  end
end
