require 'rails_helper'

RSpec.describe "MenuItems", type: :request do
  let!(:menu) { create(:menu, :lunch) }
  let!(:menu_items) { create_list(:menu_item, 5, menu: menu) }
  let(:menu_id) { menu.id }
  let(:menu_item_id) { menu_items.first.id }
  
  describe 'GET /menus/:menu_id/menu_items' do
    before { get "/menus/#{menu_id}/menu_items" }

    it 'returns menu items' do
      expect(json).not_to be_empty
      expect(json.length).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /menus/:menu_id/menu_items/:menu_item_id' do
    before { get "/menus/#{menu_id}/menu_items/#{menu_item_id}" }

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
  
  describe 'POST /menus/:menu_id/menu_items' do
    let(:valid_attributes) { { menu_item: { name: 'Black Bean Burger', description: 'A savory patty with lettuce, tomato, and onion', price: 9.99 } } }
  
    context 'when the request is valid' do
      before { post "/menus/#{menu_id}/menu_items", params: valid_attributes }
  
      it 'creates a menu item' do
        expect(json['name']).to eq('Black Bean Burger')
      end
  
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  
    context 'when the request is invalid' do
      before { post "/menus/#{menu_id}/menu_items", params: { menu_item: { name: 'Black Bean Burger' } } }  # Missing price
  
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
  
      it 'returns a validation failure message' do
        expect(json['price']).to include("can't be blank")
        expect(json['price']).to include("is not a number")
      end
    end
  end
  
  describe 'PUT /menus/:menu_id/menu_items/:menu_item_id' do
    let(:valid_attributes) { { menu_item: { name: 'Quinoa Burger', price: 11.99 } } }
  
    context 'when the menu item exists' do
      before { put "/menus/#{menu_id}/menu_items/#{menu_item_id}", params: valid_attributes }
  
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
      before { put "/menus/#{menu_id}/menu_items/#{menu_item_id}", params: valid_attributes }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
    
    context 'with invalid attributes' do
      let(:invalid_attributes) { { menu_item: { name: '', price: '' } } }
      before { put "/menus/#{menu_id}/menu_items/#{menu_item_id}", params: invalid_attributes }
  
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
  
      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
        expect(json['price']).to include("can't be blank")
      end
    end
  end
end
