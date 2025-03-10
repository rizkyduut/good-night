require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  it 'follows a user' do
    expect {
      user.follow(other_user)
    }.to change { user.following.count }.by(1)
  end

  it 'does not follow a user twice' do
    user.follow(other_user)
    expect {
      user.follow(other_user)
    }.not_to change { user.following.count }
  end

  it 'unfollows a user' do
    user.follow(other_user)
    expect {
      user.unfollow(other_user)
    }.to change { user.following.count }.by(-1)
  end

  it 'checks if following a user' do
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
  end

  it 'checks if not following a user' do
    expect(user.following?(other_user)).to be_falsey
  end

  it 'validates presence of name' do
    user = User.new
    expect(user.save).to be_falsey
    expect(user.errors[:name]).to include("can't be blank")
  end
end