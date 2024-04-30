class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_entries, dependent: :destroy
  has_many :menu_items, through: :menu_entries

  validates :name, presence: true, length: { maximum: 100 }
end
