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
end
