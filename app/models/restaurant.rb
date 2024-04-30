class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, through: :menus
  after_destroy :cleanup_orphaned_menu_items

  validates :name, presence: true,
                   length: { maximum: 100 }

  private

  def cleanup_orphaned_menu_items
    MenuItem.left_outer_joins(:menus).where(menus: { id: nil }).destroy_all
  end
end
