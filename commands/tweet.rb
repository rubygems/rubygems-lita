class Tweet < SlackRubyBot::Commands::Base
  command 'tweet'

  def self.call(client, data, match)
    username = get_username_for_channel(data)
    puts "[twitter] username = #{username.inspect}"

    require 'pry'; binding.pry

    message = match.to_a[3]
    puts "[twitter] message = #{message.inspect}"

    t = get_client(username).update(message)
    puts "[twitter] tweet = #{t.inspect}"
    send_message(client, data.channel, "Tweet posted: #{t.url}")
  end

  private

    def self.get_client(username)
      @clients ||= {}
      @clients[username] ||= ::Twitter::REST::Client.new do |c|
        c.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        c.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        c.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        c.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def self.get_username_for_channel(data)
      case data.channel
      when 'C02FM37UM' # '#rubygems-infra'
        'rubygems_status'
      when 'C02F27TKQ' #'#rubygems-org'
        'rubygems_status'
      when 'C08V1RPAP' #'#bundler'
        'bundlerio'
      else
        nil
      end
    end
end
