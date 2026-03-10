class AnalyzeApplicationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = CreditApplication.find(application_id)
    return unless application.pending?
    application.under_review!
    sleep(rand(5..15))

    # Determine the validator based on the country
    validator = CreditEvaluationFactory.validator_for(application)

    begin
      validator.validate_income_ratio
      application.approved!
    rescue => e
      application.update(
        status: :rejected,
        bank_data: application.bank_data.merge(rejection_reason: e.message)
      )
      Rails.logger.info "Application ##{application.id} rejected: #{e.message}"
    ensure
      SlackNotificationJob.perform_async(application.id, "credit_app_updated", "eval_#{application.id}")
      Rails.cache.delete_matched("credit_apps:*")
    end
  end
end
