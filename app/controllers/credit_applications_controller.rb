class CreditApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    sortable_columns = %w[id full_name country status requested_amount]
    column = sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
    direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    scope = CreditApplication.all.includes(:user)
    scope = scope.where("full_name ILIKE ?", "%#{params[:query]}%") if params[:query].present?
    scope = scope.by_country(params[:country]) if params[:country].present?

    count_cache_key = "credit_apps:count:q:#{params[:query]}:c:#{params[:country]}"
    total_count = Rails.cache.fetch(count_cache_key, expires_in: 30.minutes) do
      scope.count
    end

    @pagy, applications_scope = pagy(scope.order("#{column} #{direction}"), count: total_count)
    results_cache_key = "credit_apps:results:p#{@pagy.page}:i#{@pagy.vars[:items]}:q:#{params[:query]}:c:#{params[:country]}:s:#{column}:d:#{direction}"

    @applications = Rails.cache.fetch(results_cache_key, expires_in: 5.minutes) do
      applications_scope.to_a
    end

    pagy_headers_merge(@pagy)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          data: @applications,
          meta: pagy_metadata(@pagy)
        }
      end
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
      Rails.cache.delete_matched("credit_apps:*")
      redirect_to @application, notice: "Application created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def bulk_evaluate
    EvaluateAllPendingJob.perform_later
    redirect_to credit_applications_path, notice: "Evaluation process started for all pending applications."
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
