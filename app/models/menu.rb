class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 100 }
end
