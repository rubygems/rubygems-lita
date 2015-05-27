module ShipitAPI
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)

  extend self

  def trigger_deploy(stack, sha, as: nil)
    response = post("stacks/#{stack}/deploys", {sha: sha}, 'X-Shipit-User' => as.to_s)
    parse_response(response)
  end

  private

  def parse_response(response)
    case response.status
    when 200..299
      Hashie::Mash.new(response.body)
    when 404
      raise Error, 'Stack not found'
    when 422
      raise ValidationError, response.body.inspect
    else
      raise Error, "Unexpected error: #{response.status}"
    end
  end

  delegate :post, to: :connection
  delegate :get, to: :connection

  def connection
    @connection ||= Faraday::Connection.new('https://shipit.rubygems.org/api/') do |c|
      c.basic_auth(Lita.config.handlers.shipit.token, '')
      c.request :json
      c.response :json, content_type: /\bjson$/
      c.adapter Faraday.default_adapter
    end
  end
end
