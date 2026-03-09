class CreditApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id full_name country status requested_amount]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    query = params[:query]

    cache_key = "credit_applications:index:#{query}:#{column}:#{direction}"
    @applications = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      applications = CreditApplication.all
      if query.present?
        applications = applications.where(query)
      end

      applications.order("#{column} #{direction}").to_a
    end
  end

  def show
    @application = CreditApplication.find(params[:id])

    unless current_user.admin? || @application.user == current_user
      redirect_to root_path
    end
  end

  def new
    if current_user.credit_applications.pending.exists?
      redirect_to credit_applications_path, alert: "You already have a pending application"
      return
    end

    @application = CreditApplication.new
  end

  def edit
    @application = CreditApplication.find(params[:id])

    unless current_user.admin? || @application.user == current_user
      redirect_to credit_applications_path, alert: "Not authorized"
      return
    end

    unless @application.pending?
      redirect_to @application, alert: "Application cannot be edited"
    end
  end

  def create
    @application = current_user.applications.build(application_params)
    @application.status = :pending

    if @application.save
      Rails.cache.delete_matched("credit_applications:index*")

      redirect_to @application, notice: "Application created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:credit_application).permit(
      :country,
      :full_name,
      :document_id,
      :requested_amount,
      :monthly_income
    )
  end
end
