class UsersController < ApplicationController
  def index
    pagy, users = pagy(User.order(id: :desc))
    
    render json: { 
      data: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UserSerializer),
      pagination: pagy_metadata(pagy)
    }
  end
  
  def create
    user = User.create!(user_params)
    
    render json: user, serializer: UserSerializer, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end