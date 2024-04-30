# spec/models/menu_entry_spec.rb
require 'rails_helper'

RSpec.describe MenuEntry, type: :model do
  let(:restaurant) { Restaurant.create!(name: 'Sample Restaurant') }
  let(:menu) { restaurant.menus.create!(name: 'Sample Menu') }
  let(:menu_item) { MenuItem.create!(name: 'Sample Item', description: 'Delicious food') }

  describe 'associations' do
    it 'belongs to a menu' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: 10.00)
      expect(menu_entry.menu).to eq(menu)
    end

    it 'belongs to a menu item' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: 10.00)
      expect(menu_entry.menu_item).to eq(menu_item)
    end
  end

  describe 'validations' do
    it 'is valid with a positive price' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: 10.00)
      expect(menu_entry.valid?).to be true
    end

    it 'is invalid without a price' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: nil)
      expect(menu_entry.valid?).to be false
      expect(menu_entry.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a negative price' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: -10.00)
      expect(menu_entry.valid?).to be false
      expect(menu_entry.errors[:price]).to include('must be greater than or equal to 0')
    end
  end
end
