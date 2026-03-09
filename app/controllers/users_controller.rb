class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id first_name email created_at]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    query = params[:query]

    cache_key = "users:index:#{query}:#{column}:#{direction}"
    @users = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      users = User.all
      if query.present?
        users = users.where("first_name ILIKE ?", "%#{query}%")
      end

      users.order("#{column} #{direction}").to_a
    end
  end

  def show
    @user = User.find_by_slug(params[:id])
    unless current_user.admin? || @user == current_user
      redirect_to root_path
    end
  end

  def edit
    @user = User.find_by_slug(params[:id])
    unless current_user.admin? || @user == current_user
      redirect_to root_path
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      Rails.cache.delete_matched("users:index*")
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :name
    )
  end
end
