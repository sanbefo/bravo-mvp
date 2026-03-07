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
    @account = current_user.accounts.new(account_params)
    authorize @account

    if @account.save
      render json: @account, status: :created
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
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
