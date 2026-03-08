class CreditApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id full_name country status requested_amount]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    @applications = CreditApplication.all

    @applications = @applications.by_country(params[:country]) if params[:country].present?
    @applications = @applications.order("#{column} #{direction}")
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

  def create
    @application = current_user.applications.build(application_params)
    @application.status = :pending

    # service = CreateCreditApplication.new(application_params)
    # @application = service.call

    redirect_to @application
  rescue => e
    flash[:error] = e.message
    render :new
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
