require 'slack-ruby-bot'

module Bot
  class App < SlackRubyBot::App
  end

  require 'commands/ping'
  require 'commands/tweet'
end

Bot::App.instance.run
