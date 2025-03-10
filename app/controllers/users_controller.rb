class UsersController < ApplicationController
  def index
    page  = params[:page]  || 1
    limit = params[:limit] || 20
    limit = limit.to_i.clamp(1, 50)
    pagy, users = pagy(User.order(id: :desc), page: page, limit: limit)
    
    render json: { 
      data: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UserSerializer),
      pagination: pagy_metadata(pagy)
    }, status: :ok
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