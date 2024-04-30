require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let!(:restaurants) { create_list(:restaurant, 3) }
  let(:restaurant_id) { restaurants.first.id }

  describe 'GET /restaurants' do
    before { get '/restaurants' }

    it 'returns restaurants' do
      expect(json).not_to be_empty
      expect(json.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /restaurants/:id' do
    before { get "/restaurants/#{restaurant_id}" }

    context 'when the record exists' do
      it 'returns the restaurant' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(restaurant_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:restaurant_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Restaurant")
      end
    end
  end

  describe 'POST /restaurants' do
    let(:valid_attributes) { { name: 'El Ponce' } }

    context 'when the request is valid' do
      before { post '/restaurants', params: { restaurant: valid_attributes } }

      it 'creates a restaurant' do
        expect(json['name']).to eq('El Ponce')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/restaurants', params: { restaurant: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /restaurants/:id' do
    let(:valid_attributes) { { name: 'Slightly Different Name' } }

    context 'when the record exists' do
      before { put "/restaurants/#{restaurant_id}", params: { restaurant: valid_attributes } }

      it 'updates the record' do
        expect(json['name']).to eq('Slightly Different Name')
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { put '/restaurants/0', params: { restaurant: { name: 'New Name' } } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Restaurant/)
      end
    end

    context 'when the request is invalid' do
      before { put "/restaurants/#{restaurant_id}", params: { restaurant: { name: '' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message indicating what went wrong' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /restaurants/:id' do
    context 'when the restaurant exists' do
      before { delete "/restaurants/#{restaurant_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the restaurant does not exist' do
      before { delete '/restaurants/0' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Restaurant/)
      end
    end
  end
end
