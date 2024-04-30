require 'rails_helper'

RSpec.describe MenuEntry, type: :model do
  let(:restaurant) { Restaurant.create!(name: 'Sample Restaurant') }
  let(:menu) { restaurant.menus.create!(name: 'Sample Menu') }
  let(:menu_item) { MenuItem.create!(name: 'Sample Item', description: 'Delicious food') }
  let(:another_menu_item) { MenuItem.create!(name: 'Another Item', description: 'More delicious food') }

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
      expect(menu_entry).to be_valid
    end

    it 'is invalid without a price' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: nil)
      expect(menu_entry).to_not be_valid
      expect(menu_entry.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a negative price' do
      menu_entry = MenuEntry.new(menu:, menu_item:, price: -10.00)
      expect(menu_entry).to_not be_valid
      expect(menu_entry.errors[:price]).to include('must be greater than or equal to 0')
    end

    it 'validates uniqueness of menu_item within the same menu' do
      MenuEntry.create(menu:, menu_item:, price: 20.00)
      new_entry = MenuEntry.new(menu:, menu_item:, price: 25.00)
      expect(new_entry).to_not be_valid
      expect(new_entry.errors[:menu_item_id]).to include('should happen once per menu')
    end

    it 'allows the same menu item in different menus' do
      MenuEntry.create(menu:, menu_item:, price: 20.00)
      another_menu = restaurant.menus.create!(name: 'Another Menu')
      new_entry = MenuEntry.new(menu: another_menu, menu_item:, price: 25.00)
      expect(new_entry).to be_valid
    end
  end
end
