require 'rails_helper'

RSpec.describe 'Menus', type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menus) do
    [
      create(:menu, :lunch, restaurant:),
      create(:menu, :dinner, restaurant:),
      create(:menu, :drinks, restaurant:)
    ]
  end
  let(:menu_id) { menus.first.id }
  let(:menu_items) { create_list(:menu_item, 3) }

  before do
    menus.each do |menu|
      menu_items.each do |menu_item|
        create(:menu_entry, menu:, menu_item:)
      end
    end
  end

  describe 'GET restaurants/:id/menus/' do
    before { get "/restaurants/#{restaurant.id}/menus" }

    it 'returns menus' do
      expect(json.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET restaurants/:id/menus/:id' do
    before { get "/restaurants/#{restaurant.id}/menus/#{menu_id}" }

    context 'when the record exists' do
      it 'returns the menu with associated menu entries' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(menu_id)
        expect(json['menu_entries']).not_to be_empty
        expect(json['menu_entries'].size).to eq(3)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:menu_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end

  describe 'POST /resturants/:id/menus' do
    let(:valid_attributes) { { menu: { name: 'Breakfast' } } }

    context 'when the request is valid' do
      before { post "/restaurants/#{restaurant.id}/menus", params: valid_attributes }

      it 'creates a menu' do
        expect(json['name']).to eq('Breakfast')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/restaurants/#{restaurant.id}/menus", params: { menu: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /restaurants/:id/menus/:id' do
    let(:valid_attributes) { { menu: { name: 'Breakfast' } } }

    context 'when the menu exists' do
      before { put "/restaurants/#{restaurant.id}/menus/#{menu_id}", params: valid_attributes }

      it 'updates the menu with associated menu items' do
        expect(Menu.find(menu_id).name).to eq('Breakfast')
        expect(json['menu_entries']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the menu does not exist' do
      let(:menu_id) { 0 }

      before { put "/restaurants/#{restaurant.id}/menus/#{menu_id}", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { menu: { name: '' } } }
      before { put "/restaurants/#{restaurant.id}/menus/#{menu_id}", params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /restaurants/:id/menus/:id' do
    context 'when the menu exists' do
      let!(:menu_item1) { create(:menu_item) }
      let!(:menu_item2) { create(:menu_item) }
      let!(:menu_entry1) { create(:menu_entry, menu: menus.first, menu_item: menu_item1) }
      let!(:menu_entry2) { create(:menu_entry, menu: menus.second, menu_item: menu_item2) }
      let!(:menu_entry3) { create(:menu_entry, menu: menus.first, menu_item: menu_item2) }

      before { delete "/restaurants/#{restaurant.id}/menus/#{menu_id}" }

      it 'deletes the menu' do
        expect(Menu.exists?(menu_id)).to be_falsey
      end

      it 'does not delete menu items regardless of whether they still exist on a menu' do
        expect(MenuItem.exists?(menu_item2.id)).to be_truthy
        expect(MenuItem.exists?(menu_item1.id)).to be_truthy
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the menu does not exist' do
      let(:menu_id) { 0 }

      before { delete "/restaurants/#{restaurant.id}/menus/#{menu_id}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end
end
