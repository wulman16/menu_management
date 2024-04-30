require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'exists' do
    expect { MenuItem.new }.not_to raise_error
  end

  it 'can assign attributes' do
    menu_item = MenuItem.new(name: 'Chana Masala', price: 12.99)
    expect(menu_item.name).to eq('Chana Masala')
    expect(menu_item.price).to eq(12.99)
  end

  describe 'associations' do
    before(:each) do
      @restaurant = Restaurant.create(name: 'Surin of Thailand')
      @menu = @restaurant.menus.create(name: 'Dinner')
      @menu_item = MenuItem.create(name: 'Panang Curry', price: 15.99)
      MenuEntry.create(menu: @menu, menu_item: @menu_item)
    end

    it 'can have many menus through menu_entries' do
      expect(@menu_item.menus).to include(@menu)
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      menu_item = MenuItem.new(name: nil, price: 10)
      expect(menu_item.valid?).to be false
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'validates length of name' do
      menu_item = MenuItem.new(name: 'a' * 101, price: 10)
      expect(menu_item.valid?).to be false
      expect(menu_item.errors[:name]).to include('is too long (maximum is 100 characters)')
    end

    it 'validates presence of price' do
      menu_item = MenuItem.new(name: 'Veggie Burrito', price: nil)
      expect(menu_item.valid?).to be false
      expect(menu_item.errors[:price]).to include("can't be blank")
    end

    it 'validates numericality of price' do
      menu_item = MenuItem.new(name: 'Veggie Burrito', price: -1)
      expect(menu_item.valid?).to be false
      expect(menu_item.errors[:price]).to include('must be greater than or equal to 0')
    end

    it 'validates length of description' do
      menu_item = MenuItem.new(name: 'Veggie Burrito', price: 10, description: 'a' * 501)
      expect(menu_item.valid?).to be false
      expect(menu_item.errors[:description]).to include('is too long (maximum is 500 characters)')
    end
  end
end
