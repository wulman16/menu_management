# spec/requests/menu_items_spec.rb
require 'rails_helper'

RSpec.describe 'MenuItems', type: :request do
  let!(:menu_items) { create_list(:menu_item, 3) }
  let(:menu_item_id) { menu_items.first.id }

  describe 'GET /menu_items' do
    before { get '/menu_items' }

    it 'returns menu_items' do
      expect(json).not_to be_empty
      expect(json.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /menu_items/:id' do
    before { get "/menu_items/#{menu_item_id}" }

    context 'when the record exists' do
      it 'returns the menu_item' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(menu_item_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:menu_item_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end

  describe 'POST /menu_items' do
    let(:valid_attributes) { { name: 'New Dish', description: 'Delicious new item' } }

    context 'when the request is valid' do
      before { post '/menu_items', params: { menu_item: valid_attributes } }

      it 'creates a menu item' do
        expect(json['name']).to eq('New Dish')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/menu_items', params: { menu_item: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /menu_items/:id' do
    let(:valid_attributes) { { name: 'Updated Dish', description: 'Updated description' } }

    context 'when the record exists' do
      before { put "/menu_items/#{menu_item_id}", params: { menu_item: valid_attributes } }

      it 'updates the record' do
        updated_item = MenuItem.find(menu_item_id)
        expect(updated_item.name).to match('Updated Dish')
        expect(updated_item.description).to match('Updated description')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the updated menu item' do
        expect(json['name']).to eq('Updated Dish')
        expect(json['description']).to eq('Updated description')
      end
    end

    context 'when the record does not exist' do
      before { put '/menu_items/0', params: { menu_item: valid_attributes } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end

    context 'when the request is invalid' do
      before { put "/menu_items/#{menu_item_id}", params: { menu_item: { name: '' } } }

      it 'does not update the menu item' do
        expect(MenuItem.find(menu_item_id).name).not_to eq('')
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /menu_items/:id' do
    let(:restaurant) { create(:restaurant) }
    let(:menu) { create(:menu, :lunch, restaurant:) }
    let(:another_menu) { create(:menu, :dinner, restaurant:) }

    context 'when the record exists' do
      let!(:menu_entry) { create(:menu_entry, menu:, menu_item: menu_items.first) }

      context 'and is linked to a menu' do
        it 'does not delete the menu item and returns a conflict status' do
          expect do
            delete "/menu_items/#{menu_items.first.id}"
          end.to_not change(MenuItem, :count)
          expect(response).to have_http_status(:conflict)
          expect(response.body).to match(/Menu item is still associated with one or more menus/)
        end
      end

      context 'and is not linked to any menu' do
        before { menu_entry.destroy }

        it 'deletes the menu item' do
          expect do
            delete "/menu_items/#{menu_items.first.id}"
          end.to change(MenuItem, :count).by(-1)
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'when the record does not exist' do
      before { delete '/menu_items/0' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end
end
