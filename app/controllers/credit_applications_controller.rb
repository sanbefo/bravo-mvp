class CreditApplicationsController < ApplicationController
  def index
    sortable_columns = %w[id full_name country status requested_amount]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    @applications = CreditApplication.order("#{column} #{direction}")
  end

  def show
    @application = CreditApplication.find(params[:id])
  end

  def new
    @application = CreditApplication.new
  end

  def create
    service = CreateCreditApplication.new(application_params)

    @application = service.call

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
