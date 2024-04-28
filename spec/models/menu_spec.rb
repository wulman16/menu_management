require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'exists' do
    expect { Menu.new }.not_to raise_error
  end

  it 'can assign a name' do
    menu = Menu.new(name: 'Lunch')
    expect(menu.name).to eq('Lunch')
  end

  describe 'associations' do
    it 'has many menu_items' do
      menu = Menu.create(name: 'Breakfast')
      menu.menu_items.create(name: 'Strawberry Smoothie', price: 7.99)
      expect(menu.menu_items.size).to eq(1)
    end

    it 'destroys menu_items when destroyed' do
      menu = Menu.create(name: 'Breakfast')
      menu.menu_items.create(name: 'Strawberry Smoothie', price: 7.99)
      expect { menu.destroy }.to change(MenuItem, :count).by(-1)
    end
  end

  describe 'dependencies' do
    let(:menu) { Menu.create(name: 'Breakfast') }
    before do
      menu.menu_items.create(name: 'French Toast', price: 9.99)
    end

    it 'deletes associated menu_items when destroyed' do
      expect { menu.destroy }.to change { MenuItem.count }.by(-1)
    end
  end
end
