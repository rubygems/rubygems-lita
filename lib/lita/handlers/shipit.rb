module Lita
  module Handlers
    class Shipit < Lita::Handler
      namespace :shipit
      config :token

      route %r{^shipit\s+status\s+(?<stack>\S+)\s*}, :show_stack_status, command: true

      route %r{^(?:shipit\s+)?deploy\s+(?<stack>\S+)\s+(?<sha>\S+)\s*}, :deploy, command: true, restrict_to: :deployers

      def show_stack_status(response)
        stack = parse_stack(response)
        stack_info = ShipitAPI.get("stacks/#{stack}").body
        response.reply(stack_info.inspect)
      end

      def deploy(response)
        stack = parse_stack(response)
        sha = response.match_data[:sha].strip
        # author = pinger.github_login(response.user)
        author = response.user.name
        deploy = ShipitAPI.trigger_deploy(stack, sha, as: author)
        response.reply("Deploy triggered: #{deploy.html_url}")
      rescue ShipitAPI::Error => error
        response.reply(error.message)
      end

      private

      def parse_stack(response)
        stack = response.match_data[:stack].strip
        parts = stack.split('/')
        parts << 'production' if parts.size == 1
        parts.unshift('rubygems') if parts.size == 2
        parts.join('/')
      end
    end
    Lita.register_handler(Shipit)
  end
end
