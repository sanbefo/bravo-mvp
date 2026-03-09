class SlackNotificationJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)

    Slack::Notifier.user_created(user)
  end
end
