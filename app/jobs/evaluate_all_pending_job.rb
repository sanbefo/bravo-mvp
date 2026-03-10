class EvaluateAllPendingJob < ApplicationJob
  queue_as :default

  def perform
    CreditApplication.pending.find_each do |application|
      AnalyzeApplicationJob.perform_later(application.id)
    end
  end
end
