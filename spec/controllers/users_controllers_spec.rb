require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'Test User' } }
    let(:invalid_attributes) { { name: '' } }

    it 'creates a new user with valid attributes' do
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'does not create a new user with invalid attributes' do
      expect {
        post :create, params: { user: invalid_attributes }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end