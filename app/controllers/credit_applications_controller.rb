class CreditApplicationsController < ApplicationController

  def index
    @applications = CreditApplication.all
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
