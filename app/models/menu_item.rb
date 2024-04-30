class MenuItem < ApplicationRecord
  has_many :menu_entries, dependent: :destroy
  has_many :menus, through: :menu_entries

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
