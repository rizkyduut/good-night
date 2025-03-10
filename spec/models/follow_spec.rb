require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  it 'creates a follow relation' do
    follow = Follow.new(follower: user, followed: other_user)
    expect(follow.save).to be_truthy
  end

  it 'does not allow duplicate follow relation' do
    Follow.create!(follower: user, followed: other_user)
    duplicate_follow = Follow.new(follower: user, followed: other_user)
    expect(duplicate_follow.save).to be_falsey
    expect(duplicate_follow.errors[:follower_id]).to include("Already following this user")
  end

  it 'does not allow self-follow' do
    follow = Follow.new(follower: user, followed: user)
    expect(follow.save).to be_falsey
    expect(follow.errors[:follower_id]).to include("You can't follow yourself.")
  end
end