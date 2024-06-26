require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it 'exists' do
    expect { Restaurant.new }.not_to raise_error
  end

  it 'can assign a name' do
    restaurant = Restaurant.new(name: 'La Fonda')
    expect(restaurant.name).to eq('La Fonda')
  end

  describe 'validations' do
    it 'validates presence of name' do
      restaurant = Restaurant.new(name: nil)
      expect(restaurant.valid?).to be false
      expect(restaurant.errors[:name]).to include("can't be blank")
    end

    it 'validates length of name' do
      restaurant = Restaurant.new(name: 'a' * 101)
      expect(restaurant.valid?).to be false
      expect(restaurant.errors[:name]).to include('is too long (maximum is 100 characters)')
    end
  end

  describe 'associations' do
    it 'has many menus' do
      restaurant = Restaurant.create(name: 'Surin of Thailand')
      restaurant.menus.create(name: 'Dinner')
      expect(restaurant.menus.size).to eq(1)
    end

    it 'destroys menus when destroyed' do
      restaurant = Restaurant.create(name: 'Surin of Thailand')
      restaurant.menus.create(name: 'Dinner')
      expect { restaurant.destroy }.to change(Menu, :count).by(-1)
    end
  end
end
