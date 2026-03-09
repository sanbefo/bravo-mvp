class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id first_name email created_at]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    @users = User.all
    @users = params[:query].present? ? User.where("first_name ILIKE ?", "%#{params[:query]}%") : User.all
    @users = @users.order("#{column} #{direction}")
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
    user = User.create!(user_params)

    SlackNotificationJob.perform_async(
      "New user created: #{user.email}"
    )

    render json: user, status: :created
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
