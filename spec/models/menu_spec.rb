require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'exists' do
    expect { Menu.new }.not_to raise_error
  end

  it 'can assign a name' do
    menu = Menu.new(name: 'Lunch')
    expect(menu.name).to eq('Lunch')
  end
end
