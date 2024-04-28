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

  it 'belongs to a menu' do
    should belong_to(:menu)
  end
end
