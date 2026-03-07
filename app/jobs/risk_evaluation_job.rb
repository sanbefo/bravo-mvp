class RiskEvaluationJob
  include Sidekiq::Job

  sidekiq_options retry: 3

  def perform(application_id)
    application = CreditApplication.find(application_id)

    evaluate(application)
  end

  private

  def evaluate(application)
    if high_risk?(application)
      application.update!(status: :under_review)
    else
      application.update!(status: :approved)
    end
  end

  def high_risk?(application)
    bank_data = application.bank_data

    score = bank_data['credit_score'] || 700
    debts = bank_data['debts'] || 0

    score < 600 || debts > 3000
  end
end
