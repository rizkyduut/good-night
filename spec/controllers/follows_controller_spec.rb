require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_session) { { user_id: user.id } }

  describe 'POST #follow' do
    it 'follows a user' do
      expect {
        post :follow, params: { user_id: user.id, followed_id: other_user.id }, session: valid_session
      }.to change(Follow, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'does not follow a user twice' do
      user.follow(other_user)
      post :follow, params: { user_id: user.id, followed_id: other_user.id }, session: valid_session
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #unfollow' do
    it 'unfollows a user' do
      user.follow(other_user)
      expect {
        post :unfollow, params: { user_id: user.id, followed_id: other_user.id }, session: valid_session
      }.to change(Follow, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if not following the user' do
      post :unfollow, params: { user_id: user.id, followed_id: other_user.id }, session: valid_session
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end