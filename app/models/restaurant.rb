class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, through: :menus

  validates :name, presence: true,
                   length: { maximum: 100 }
end
