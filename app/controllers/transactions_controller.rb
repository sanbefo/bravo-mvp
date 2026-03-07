class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    source = current_user.accounts.friendly.find(params[:source_account_id])
    destination = Account.friendly.find(params[:destination_account_id])

    amount = Money.from_amount(params[:amount].to_f, source.currency)

    service = Transactions::Create.new(
      source_account: source,
      destination_account: destination,
      amount: amount
    )

    result = service.call

    if result.success?
      render json: result.transaction, status: :created
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
end
