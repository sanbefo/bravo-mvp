class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?

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
end
