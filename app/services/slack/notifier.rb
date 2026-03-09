require "net/http"
require "uri"
require "json"

module Slack
  class Notifier
    def user_created(user, request_id)
      webhook_url = Rails.application.credentials.slack[:webhook_url]

      uri = URI.parse(webhook_url)

      payload = {
        text: "👤 New user created",
        blocks: [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*New user registered*"
            }
          },
          {
            type: "section",
            fields: [
              {
                type: "mrkdwn",
                text: "*User ID:*\n#{user.id}"
              },
              {
                type: "mrkdwn",
                text: "*Full Name:*\n#{user.full_name}"
              },
              {
                type: "mrkdwn",
                text: "*Email:*\n#{user.email}"
              }
            ]
          }
        ]
      }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      request.body = payload.to_json

      http.request(request)
    end
  end
end
