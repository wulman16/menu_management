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
  
  describe 'POST /menus' do
    let(:valid_attributes) { { menu: { name: 'Breakfast' } } }

    context 'when the request is valid' do
      before { post '/menus', params: valid_attributes }

      it 'creates a menu' do
        expect(json['name']).to eq('Breakfast')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/menus', params: { menu: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end
  
  describe 'PUT /menus/:id' do
    let(:valid_attributes) { { menu: { name: 'Breakfast' } } }

    context 'when the menu exists' do
      before { put "/menus/#{menu_id}", params: valid_attributes }

      it 'updates the menu' do
        expect(Menu.find(menu_id).name).to eq('Breakfast')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the menu does not exist' do
      let(:menu_id) { 0 }

      before { put "/menus/#{menu_id}", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
    
    context 'with invalid attributes' do
      let(:invalid_attributes) { { menu: { name: '' } } }
      before { put "/menus/#{menu_id}", params: invalid_attributes }
  
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
  
      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end
  
  describe 'DELETE /menus/:id' do
    context 'when the menu exists' do
      before { delete "/menus/#{menu_id}" }

      it 'deletes the menu' do
        expect(Menu.exists?(menu_id)).to be_falsey
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the menu does not exist' do
      let(:menu_id) { 0 }

      before { delete "/menus/#{menu_id}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end
end
