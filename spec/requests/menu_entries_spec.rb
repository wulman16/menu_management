require 'rails_helper'

RSpec.describe 'MenuEntries', type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:menu) { create(:menu, restaurant:) }
  let(:menu_item) { create(:menu_item) }
  let(:another_menu_item) { create(:menu_item) } # Different menu item for uniqueness tests
  let(:menu_entry) { create(:menu_entry, menu:, menu_item:, price: 15.00) }
  let(:menu_entry_id) { menu_entry.id }

  describe 'POST /menu_entries' do
    let(:valid_attributes) { { menu_item_id: another_menu_item.id, price: 9.99 } }

    context 'when the request is valid' do
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries", params: { menu_entry: valid_attributes }
      end

      it 'creates a menu entry' do
        expect(json['price']).to eq('9.99')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid due to missing menu_item_id' do
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries", params: { menu_entry: { price: 9.99 } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['menu_item']).to include('must exist')
      end
    end

    context 'when attempting to add a duplicate menu_item to the same menu' do
      before do
        post "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries",
             params: { menu_entry: valid_attributes }
        post "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries",
             params: { menu_entry: valid_attributes }
      end

      it 'does not create a duplicate menu entry' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message for uniqueness' do
        expect(json['menu_item_id']).to include('should happen once per menu')
      end
    end
  end

  describe 'DELETE /menu_entries/:id' do
    context 'when the menu entry exists' do
      before { delete "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries/#{menu_entry_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the menu entry does not exist' do
      before { delete "/restaurants/#{restaurant.id}/menus/#{menu.id}/menu_entries/99999" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
