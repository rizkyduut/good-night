require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_session) { { user_id: user.id } }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, params: { user_id: user.id }, session: valid_session
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #clock_in' do
    it 'creates a new sleep record' do
      expect {
        post :clock_in, params: { user_id: user.id }, session: valid_session
      }.to change(SleepRecord, :count).by(1)
      expect(response).to have_http_status(:ok)
    end

    it 'does not create a new sleep record if there is an active session' do
      create(:sleep_record, user: user, clock_in: Time.current)
      post :clock_in, params: { user_id: user.id }, session: valid_session
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #clock_out' do
    it 'clocks out an active sleep record' do
      sleep_record = create(:sleep_record, user: user, clock_in: Time.current)
      post :clock_out, params: { user_id: user.id }, session: valid_session
      sleep_record.reload
      expect(sleep_record.clock_out).not_to be_nil
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if there is no active session' do
      post :clock_out, params: { user_id: user.id }, session: valid_session
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #following' do
    it 'returns a successful response' do
      get :following, params: { user_id: user.id }, session: valid_session
      expect(response).to have_http_status(:ok)
    end
  end
end