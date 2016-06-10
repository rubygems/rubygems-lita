module Lita
  module Handlers
    class TestGemPush < Lita::Handler
      namespace :test_gem_push
      config :token

      route %r{^test_gem_push(?:\s(.+))?},
            :test_gem_push,
            command: true,
            restrict_to: :deployers,
            help: { "test_gem_push VERSION" => "Test pushing a new gem." }

      def test_gem_push(response)
        version = response.match_data[1]
        log.debug "[test_gem_push] version = #{version.inspect}"

        post = { token: config.token, version: version }.reject { |_, v| v.nil? }
        r = Faraday::Connection.new("https://rubygems-test-gem-push.herokuapp.com").post("/", post)
        log.debug "[test_gem_push] response = #{r.inspect}"
        response.reply("[test_gem_push] #{r.body}")
      end

    end
    Lita.register_handler(TestGemPush)
  end
end
