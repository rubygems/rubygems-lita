module Lita
  module Handlers
    class Twitter < Lita::Handler
      namespace :twitter
      config :consumer_key
      config :consumer_secret
      config :accounts

      route %r{^tweet\s(.+)}, :tweet, command: true, restrict_to: :tweeters, help: {"tweet MESSAGE" => "Post a tweet."}

      def tweet(response)
        username = get_username_for_channel(Channels.name_from_id(response.message.source.room))
        log.debug "[twitter] username = #{username.inspect}"
        return false if username.nil?

        message = response.match_data[1]
        log.debug "[twitter] message = #{message.inspect}"

        t = get_client(username).update(message)
        log.debug "[twitter] tweet = #{t.inspect} #{t.url}"
        response.reply("Tweet posted!")
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
        log.debug "[twitter] channel = #{channel.inspect}"
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
