class MenuEntry < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :menu_item_id, uniqueness: { scope: :menu_id, message: 'should happen once per menu' }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
