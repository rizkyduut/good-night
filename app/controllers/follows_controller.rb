class FollowsController < ApplicationController
  before_action :set_user

  def follow
    followed_user = User.find(params[:followed_id])

    if @user.following?(followed_user)
      return render json: { message: "Already following this user" }, status: :unprocessable_entity
    end

    follow_relation = @user.follow_list.build(followed: followed_user)

    if follow_relation.save
      render json: { message: "Successfully followed user", data: followed_user }, status: :created
    else
      render json: { message: follow_relation.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  def unfollow
    followed_user = User.find(params[:followed_id])
    follow_relation = @user.follow_list.find_by(followed: followed_user)

    if follow_relation.nil?
      return render json: { message: "You are not following this user" }, status: :unprocessable_entity
    end

    follow_relation.destroy

    render json: { message: "Successfully unfollowed user" }, status: :ok
  end

  private 

  def set_user
    @user = User.find(params[:user_id])
  end
end