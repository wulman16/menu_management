require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'exists' do
    expect { MenuItem.new }.not_to raise_error
  end

  it 'can assign attributes' do
    menu_item = MenuItem.new(name: 'Chana Masala',
                             description: 'Spicy, tangy chickpea curry with tomatoes, onions, and aromatic spices')
    expect(menu_item.name).to eq('Chana Masala')
    expect(menu_item.description).to eq('Spicy, tangy chickpea curry with tomatoes, onions, and aromatic spices')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      menu_item = MenuItem.new(name: 'Chana Masala',
                               description: 'Spicy, tangy chickpea curry with tomatoes, onions, and aromatic spices')
      expect(menu_item).to be_valid
    end

    it 'is not valid without a name' do
      menu_item = MenuItem.new(name: nil,
                               description: 'Spicy, tangy chickpea curry with tomatoes, onions, and aromatic spices')
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a name longer than 100 characters' do
      menu_item = MenuItem.new(name: 'a' * 101,
                               description: 'Spicy, tangy chickpea curry with tomatoes, onions, and aromatic spices')
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include('is too long (maximum is 100 characters)')
    end

    it 'is not valid with a description longer than 500 characters' do
      menu_item = MenuItem.new(name: 'Veggie Burrito', description: 'a' * 501)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:description]).to include('is too long (maximum is 500 characters)')
    end

    it 'is not valid with a duplicate name' do
      MenuItem.create(name: 'Chana Masala')
      menu_item = MenuItem.new(name: 'Chana Masala')
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    before(:each) do
      @restaurant = Restaurant.create(name: 'Surin of Thailand')
      @menu = @restaurant.menus.create(name: 'Dinner')
      @menu_item = MenuItem.create(name: 'Panang Curry')
      MenuEntry.create(menu: @menu, menu_item: @menu_item, price: 15.99)
    end

    it 'can have many menus through menu_entries' do
      expect(@menu_item.menus).to include(@menu)
    end
  end
end
