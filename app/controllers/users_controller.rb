class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id first_name email created_at]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    query = params[:query]

    scope = User.all
    scope = scope.where("first_name ILIKE ? OR email ILIKE ?", "%#{query}%", "%#{query}%") if query.present?

    count_cache_key = "users:count:q:#{query}"
    total_count = Rails.cache.fetch(count_cache_key, expires_in: 30.minutes) do
      scope.count
    end

    @pagy, users_scope = pagy(scope.order("#{column} #{direction}"), count: total_count)

    results_cache_key = "users:results:p#{@pagy.page}:i#{@pagy.vars[:items]}:q:#{query}:s:#{column}:d:#{direction}"
    @users = Rails.cache.fetch(results_cache_key, expires_in: 10.minutes) do
      users_scope.to_a
    end

    pagy_headers_merge(@pagy)
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
    @user = User.new(user_params)

    if @user.save
      Rails.cache.delete_matched("users:*")
      respond_to do |format|
        format.html { redirect_to @user, notice: "User created." }
        format.json { render json: @user, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
