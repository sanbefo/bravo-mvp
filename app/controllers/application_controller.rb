class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :log_action_details, :set_request_details, :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # For the sign up page
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :document])
    # For the account update page
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :document])
  end

  private

  def user_not_authorized
    render json: { error: "Not authorized" }, status: :forbidden
  end

  def set_request_details
    # Rails automatically generates a UUID for every request
    Current.request_id = request.request_id
  end

  def log_action_details
    # This gives you a clear start line for every request
    Rails.logger.info "--- [Action: #{controller_name}##{action_name}] [ID: #{request.request_id}] ---"
  end

  def set_current_request_id
    Current.request_id = request.request_id
    Current.user_id = current_user&.id # if using Devise
  end
end
