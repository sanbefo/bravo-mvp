class EvaluateAllPendingJob < ApplicationJob
  queue_as :default

  def perform
    pending_ids = CreditApplication.pending.pluck(:id)
    pending_ids.each do |app_id|
      AnalyzeApplicationJob.perform_later(app_id)
    end
  end
end
