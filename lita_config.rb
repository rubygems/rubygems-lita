require_relative 'lib/lita/handlers/deploy_notifications'
require_relative 'lib/lita/handlers/expire_new_index'
require_relative 'lib/lita/handlers/shipit'
require_relative 'lib/lita/handlers/shipit_notifications'
require_relative 'lib/lita/handlers/test_gem_push'
require_relative 'lib/lita/handlers/twitter'
require_relative 'lib/channels'
require_relative 'lib/shipit_api'

require "lita-slack" if ENV["SLACK_TOKEN"]
require 'twitter'

Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = "Lita"

  # The locale code for the language to use.
  config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :debug

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  config.robot.admins = (ENV["LITA_ADMINS"] || "").split(",")

  # The adapter you want to connect with. Make sure you've added the
  # appropriate gem to the Gemfile.
  if ENV["SLACK_TOKEN"]
    config.robot.adapter = :slack
    config.adapters.slack.token = ENV["SLACK_TOKEN"]
    config.adapters.slack.link_names = true
    config.adapters.slack.parse = "none"
    config.adapters.slack.unfurl_links = false
    config.adapters.slack.unfurl_media = false
  else
    config.robot.adapter = :shell
  end

  ## Example: Set options for the chosen adapter.
  # config.adapter.username = "myname"
  # config.adapter.password = "secret"

  ## Example: Set options for the Redis connection.
  # config.redis.host = "127.0.0.1"
  # config.redis.port = 1234
  config.redis[:url] = ENV["REDISTOGO_URL"] || "redis://localhost:6379"
  config.http.port = ENV["PORT"] || "6000"

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.
  # config.handlers.some_handler.some_config_key = "value"

  config.handlers.shipit.token = ENV["SHIPIT_TOKEN"]

  config.handlers.twitter.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
  config.handlers.twitter.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
  config.handlers.twitter.accounts = ENV["TWITTER_ACCOUNTS"]

  config.handlers.test_gem_push.token = ENV["TEST_GEM_PUSH_TOKEN"]

  config.handlers.expire_new_index.service_id = ENV["FASTLY_SERVICE_ID"]
  config.handlers.expire_new_index.base_url = ENV["FASTLY_BASE_URL"]
  config.handlers.expire_new_index.api_key = ENV["FASTLY_API_KEY"]

end
