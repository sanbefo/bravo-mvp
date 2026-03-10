class AnalyzeApplicationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = CreditApplication.find(application_id)
    return unless application.pending?
    application.under_review!
    sleep(rand(10..40))

    # 3. Apply your "Rules" (placeholder for now)
    application.monthly_income > 2000 ? application.approved! : application.rejected!
    Rails.cache.delete_matched("credit_apps:*")

    SlackNotificationJob.perform_async(self.id, "credit_app_updated", Current.request_id)
  end
end
