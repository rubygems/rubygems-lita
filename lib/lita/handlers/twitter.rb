module Lita
  module Handlers
    class Twitter < Lita::Handler
      namespace :twitter
      config :consumer_key
      config :consumer_secret
      config :accounts

      route %r{^tweet\s(.+)}, :tweet, command: true, help: {"tweet MESSAGE" => "Post a tweet."}

      def tweet(response)
        username = get_username_for_channel(response.message.source.room)
        log.debug "[twitter] username = #{username.inspect}"
        return false if username.nil?

        message = response.match_data[1]
        log.debug "[twitter] message = #{message.inspect}"

        t = get_client(username).update(message)
        log.debug "[twitter] tweet = #{t.inspect}"
        response.reply("Tweet posted: #{t.url}")
      end

      private

      def get_client(username)
        @clients ||= {}
        raise "TWITTER_ACCOUNTS env variable must be set!" unless config.accounts
        creds = JSON.parse(config.accounts)[username]
        raise "Credentials not found for: #{username}" unless creds
        @clients[username] ||= ::Twitter::REST::Client.new do |c|
          c.consumer_key        = config.consumer_key
          c.consumer_secret     = config.consumer_secret
          c.access_token        = creds['access_token']
          c.access_token_secret = creds['access_token_secret']
        end
      end

      def get_username_for_channel(channel)
        case channel
        when 'rubygems-org', 'rubygems-infra'
          'rubygems_status'
        when 'bundler'
          'bundlerio'
        else
          nil
        end
      end

    end
    Lita.register_handler(Twitter)
  end
end
