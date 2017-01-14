class UsersController < ApplicationController

  before_action :authenticate_with_token!, only: [:get_place]

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 409
    end
  end

  def get_leaderboard
    @users = User.all.order(:place)
    render json: @users, except: [:auth_token, :created_at, :updated_at], status: 200
  end

  def update_place
    if current_user.update(update_user_params)
      evaluate_places
      current_user.reload
      render json: current_user, except: [:auth_token, :created_at, :updated_at], status: 200
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname)
  end

  def update_user_params
    params.require(:user).permit(:score)
  end

  # Reevaluates user places based on their score
  def evaluate_places
    @users = User.all.order(score: :desc)
    place = 1;
    @users.each do |user|
      user.place = place
      place += 1
      user.save
    end
  end

  # Render error if cannot find user with given auth_token or auth_token
  # not given
  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  # Sets a user as current_user if there is a user in database with the given auth_token
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
end
