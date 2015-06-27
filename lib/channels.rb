module Channels
  extend self

  def [](channel_name)
    name = channel_name.to_s.gsub(/\A#/, '')
    return unless channels.include?(name)
    Lita::Source.new(room: channels[name])
  end

  def name_from_id(id)
    channels.find { |k,v| v == id }[0]
  end

  private

  def channels
    @channels ||= fetch_channels
  end

  def fetch_channels
    url = "https://slack.com/api/channels.list?token=#{Lita.config.adapters.slack.token}"
    payload = JSON.load(Faraday.get(url).body)
    payload['channels'].map { |c| [c['name'], c['id']]}.to_h
  end
end
