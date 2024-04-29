require 'rails_helper'

RSpec.describe 'Menus', type: :request do
  let!(:menus) { [create(:menu, :lunch), create(:menu, :dinner), create(:menu, :drinks)] }
  let(:menu_id) { menus.first.id }
  
  describe 'GET /menus' do
    before { get '/menus' }

    it 'returns menus' do
      expect(json).not_to be_empty
      expect(json.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /menus/:id' do
    before { get "/menus/#{menu_id}" }

    context 'when the record exists' do
      it 'returns the menu' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(menu_id)
        expect(json['name']).to eq('Lunch')
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
end
