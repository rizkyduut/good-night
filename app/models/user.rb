class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy

  has_many :follow_list, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :follow_list, source: :followed

  has_many :follower_list, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :follower_list, source: :follower

  validates :name, presence: true

  def follow(user)
    following << user unless following.include?(user)
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end
end
