class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 409
    end
  end

  def user_params
    params.require(:user).permit(:nickname)
  end
end
