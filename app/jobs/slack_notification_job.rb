class SlackNotificationJob
  include Sidekiq::Job
  sidekiq_options queue: 'default', retry: 3

  def perform(user_id, request_id = "internal-system")
    user = User.find_by(id: user_id)
    return unless user

    # This line makes your logs look professional:
    Rails.logger.info "[Request:#{request_id}] STARTING: Sending Slack notification for #{user.id}"

    begin
      Slack::Notifier.new.user_created(user, request_id)
      Rails.logger.info "[Request:#{request_id}] SUCCESS: Slack notification sent."
    rescue => e
      Rails.logger.error "[Request:#{request_id}] FAILED: #{e.message}"
      raise e # Re-raise so Sidekiq retries if needed
    end
  end
end
