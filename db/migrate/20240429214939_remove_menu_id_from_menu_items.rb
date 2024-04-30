class RemoveMenuIdFromMenuItems < ActiveRecord::Migration[7.1]
  def change
    remove_index :menu_items, name: :index_menu_items_on_menu_id
    remove_column :menu_items, :menu_id
  end
end
