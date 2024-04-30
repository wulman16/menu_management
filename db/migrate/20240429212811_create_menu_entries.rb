class CreateMenuEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_entries do |t|
      t.belongs_to :menu, null: false, foreign_key: true
      t.belongs_to :menu_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
