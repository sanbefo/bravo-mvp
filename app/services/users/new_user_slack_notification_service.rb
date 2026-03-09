class NewUserSlackNotificationService
  def self.create(params)
    credit = CreditApplication.create!(params)

    SlackNotificationJob.perform_async(
      "There's a new user in the app!"
      # "New credit application ##{credit.id} created for #{credit.customer_name}"
    )

    credit
  end
end
