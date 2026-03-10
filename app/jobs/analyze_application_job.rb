class AnalyzeApplicationJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = CreditApplication.find(application_id)
    return unless application.pending?
    application.under_review!
    sleep(rand(60..120))

    # 3. Apply your "Rules" (placeholder for now)
    # Simple logic: Approve if income > 2000, else reject
    application.monthly_income > 2000 ? application.approved! : application.rejected!
    Rails.cache.delete_matched("credit_apps:*")

    # 5. Optional: Notify Slack (since you already have that job)
    # SlackNotificationJob.perform_later("Application #{application.id} was #{application.status}")
  end
end
