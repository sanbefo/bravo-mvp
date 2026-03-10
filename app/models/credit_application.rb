class CreditApplication < ApplicationRecord

  belongs_to :user
  enum :country, { MX: 0, PT: 1 }
  enum :currency, { mexico: "MXN", portugal: "EUR" }
  enum :status, { pending: 0, under_review: 1, rejected: 2, approved: 3 }

  validates :country, :currency, :full_name, :document_id, :requested_amount, :monthly_income, presence: true
  validate :only_one_pending_application, on: :create
  scope :by_country, ->(country_code) { where(country: country_code) }
  scope :by_status, ->(status) { where(status: status) }
  after_commit :broadcast_pending_count
  after_update_commit :notify_slack_on_status_change, if: :saved_change_to_status?
  after_update_commit -> {
    broadcast_replace_to "credit_applications",
    target: "credit_application_#{id}",
    partial: "credit_applications/credit_application",
    locals: { credit_application: self }
  }
  after_create_commit -> {
    broadcast_prepend_to "credit_applications",
    target: "credit_applications_table",
    partial: "credit_applications/credit_application",
    locals: { credit_application: self }
  }

  private

  def only_one_pending_application
    if user.credit_applications.pending.exists?
      errors.add(:base, "You already have a pending credit application")
    end
  end

  def notify_slack_on_status_change
    SlackNotificationJob.perform_async(id, "credit_app_updated", Current.request_id)
  end

  def broadcast_pending_count
    broadcast_update_to(
      "credit_applications",
      target: "pending_count",
      html: CreditApplication.pending.count.to_s
    )
  end
end
