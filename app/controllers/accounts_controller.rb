class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: :show

  def index
    @accounts = Account.includes(:user).all

    render json: @accounts
  end

  def show
    authorize @account
    render json: @account
  end

  def create
    service = Accounts::Create.new(
      user: current_user,
      params: account_params
    )

    result = service.call
    authorize result.account if result.success?

    if result.success?
      render json: result.account, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = Account.friendly.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:bank_name, :account_number, :country)
  end
end
