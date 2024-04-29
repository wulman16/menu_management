require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'exists' do
    expect { Menu.new }.not_to raise_error
  end

  it 'can assign a name' do
    menu = Menu.new(name: 'Lunch')
    expect(menu.name).to eq('Lunch')
  end
  
  describe 'validations' do
    it 'validates presence of name' do
      menu = Menu.new(name: nil)
      expect(menu.valid?).to be false
      expect(menu.errors[:name]).to include("can't be blank")
    end

    it 'validates length of name' do
      menu = Menu.new(name: 'a' * 101)
      expect(menu.valid?).to be false
      expect(menu.errors[:name]).to include("is too long (maximum is 100 characters)")
    end
  end

  describe 'associations' do
    before(:each) do
      @restaurant = Restaurant.create(name: 'East Pole Coffee')
      @menu = @restaurant.menus.create(name: 'Hot Coffees')
    end
    
    it 'belongs to a restaurant' do
      expect(@menu.restaurant).to eq(@restaurant)
    end
    
    it 'has many menu_items' do
      @menu.menu_items.create(name: 'Strawberry Smoothie', price: 7.99)
      expect(@menu.menu_items.size).to eq(1)
    end

    it 'destroys menu_items when destroyed' do
      @menu.menu_items.create(name: 'Strawberry Smoothie', price: 7.99)
      expect { @menu.destroy }.to change(MenuItem, :count).by(-1)
    end
  end

  describe 'dependencies' do
    before do
      @restaurant = Restaurant.create(name: 'East Pole Coffee')
      @menu = @restaurant.menus.create(name: 'Hot Coffees')
      @menu.menu_items.create(name: 'Strawberry Smoothie', price: 7.99)
    end

    it 'deletes associated menu_items when destroyed' do
      expect { @menu.destroy }.to change { MenuItem.count }.by(-1)
    end
  end
end
