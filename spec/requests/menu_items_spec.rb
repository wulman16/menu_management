require 'rails_helper'

RSpec.describe 'MenuItems', type: :request do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, :lunch, restaurant:) }
  let!(:second_menu) { create(:menu, :dinner, restaurant:) }
  let(:menu_id) { menu.id }
  let(:second_menu_id) { second_menu.id }
  let(:menu_items) { create_list(:menu_item, 3) }
  let(:menu_item_id) { menu_items.first.id }

  before do
    menu_items.each do |menu_item|
      create(:menu_entry, menu:, menu_item:)
    end
  end

  describe 'GET /restaurants/:id/menus/:id/menu_items' do
    before { get "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items" }

    it 'returns menu items' do
      expect(json).not_to be_empty
      expect(json.length).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /restaurants/:id/menus/:id/menu_items/:id' do
    before { get "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}" }

    context 'when menu item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(menu_item_id)
      end
    end

    context 'when the menu item does not exist' do
      let(:menu_item_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end

  describe 'POST /restaurants/:id/menus/:id/menu_items' do
    let(:valid_attributes) do
      { menu_item: { name: 'Black Bean Burger', description: 'A savory patty with lettuce, tomato, and onion',
                     price: 9.99 } }
    end

    context 'when the request is valid' do
      before { post "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items", params: valid_attributes }

      it 'creates a menu item' do
        expect(json['name']).to eq('Black Bean Burger')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      # Missing price
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items",
             params: { menu_item: { name: 'Black Bean Burger' } }
      end
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['price']).to include("can't be blank")
        expect(json['price']).to include('is not a number')
      end
    end

    context 'when the menu item already exists on another menu' do
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items", params: valid_attributes
        post "/restaurants/#{restaurant.id}/menus/#{second_menu_id}/menu_items", params: valid_attributes
      end

      it 'associates the existing menu item with the new menu' do
        expect(json['name']).to eq('Black Bean Burger')
        expect(Menu.find(second_menu_id).menu_items).to include(MenuItem.find_by(name: 'Black Bean Burger'))
      end
    end

    context 'when the menu item already exists on the same menu' do
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items", params: valid_attributes
        post "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items", params: valid_attributes
      end

      it 'returns status code 409' do
        expect(response).to have_http_status(409)
      end

      it 'returns an error message indicating the menu item already exists on the menu' do
        expect(json['error']).to eq('Menu item already exists on this menu.')
      end
    end
  end

  describe 'PUT /restaurants/:id/menus/:id/menu_items/:id' do
    let(:valid_attributes) { { menu_item: { name: 'Quinoa Burger', price: 11.99 } } }

    context 'when the menu item exists' do
      before do
        put "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}", params: valid_attributes
      end

      it 'updates the record' do
        updated_item = JSON.parse(response.body)
        expect(updated_item['name']).to eq('Quinoa Burger')
        expect(updated_item['price']).to eq('11.99')
      end

      it 'returns the updated menu item' do
        expect(response.body).to include('Quinoa Burger')
        expect(response.body).to include('11.99')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the menu item does not exist' do
      let(:menu_item_id) { 0 }
      before do
        put "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}", params: valid_attributes
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { menu_item: { name: '', price: '' } } }
      before do
        put "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}", params: invalid_attributes
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
        expect(json['price']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /restaurants/:id/menus/:id/menu_items/:id' do
    context 'when the menu item exists' do
      before { delete "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}" }

      it 'deletes the record' do
        expect(Menu.find(menu_id).menu_items).not_to include(menu_item_id)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the menu item does not exist' do
      let(:menu_item_id) { 0 }
      before { delete "/restaurants/#{restaurant.id}/menus/#{menu_id}/menu_items/#{menu_item_id}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end
end
