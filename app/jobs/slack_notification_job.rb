require 'net/http'

class SlackNotificationJob
  include Sidekiq::Job
  sidekiq_options queue: 'default', retry: 3

  def perform(record_id, type, request_id = "internal-system")
    case type
    when "user_created"
      record = User.find_by(id: record_id)
      webhook_url = Rails.application.credentials.dig(:slack, :new_users_webhook)
      message = "👤 *New User Registered:* #{record&.first_name} (#{record&.email})"
    when "credit_app_updated"
      record = CreditApplication.find_by(id: record_id)
      webhook_url = Rails.application.credentials.dig(:slack, :credit_apps_webhook)
      message = "💳 *Credit Application Update:* ##{record&.id} for #{record&.full_name} is now *#{record&.status&.upcase}*"
    end

    return unless record && webhook_url

    Rails.logger.info "[Request:#{request_id}] STARTING: Slack notification for #{type} (ID: #{record_id})"

    begin
      send_to_slack(webhook_url, message)
      Rails.logger.info "[Request:#{request_id}] SUCCESS: Slack notification sent."
    rescue => e
      Rails.logger.error "[Request:#{request_id}] FAILED: #{e.message}"
      raise e
    end
  end

  private

  def send_to_slack(url_string, message)
    uri = URI.parse(url_string.strip) # strip removes any accidental white space

    # Create the request
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = { text: message }.to_json

    # Execute the request with SSL enabled
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.code == "200"
      Rails.logger.error "----------------------Slack Error: #{response.body}"
    end
  end
end
