require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'exists' do
    expect { Menu.new }.not_to raise_error
  end

  it 'can assign a name' do
    menu = Menu.new(name: 'Lunch')
    expect(menu.name).to eq('Lunch')
  end

  it 'has many menu_items' do
    should have_many(:menu_items).dependent(:destroy)
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
