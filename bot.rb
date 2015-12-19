require 'slack-ruby-bot'

module Bot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'ping' do |client, data, _match|
      client.message(text: 'pong', channel: data.channel)
    end
  end
end

Bot::App.instance.run
