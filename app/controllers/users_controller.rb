class UsersController < ApplicationController
  include Pagy::Backend

  def index
    pagy, users = pagy(User.order(id: :desc))
    
    render json: { 
      data: users,
      pagination: pagy_metadata(pagy)
    }
  end
  
  def create
    user = User.create!(user_params)
    
    render json: user, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end