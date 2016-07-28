module Lita
  module Handlers
    class ExpireNewIndex < Lita::Handler
      namespace :expire_new_index

      config :service_id
      config :base_url
      config :api_key

      route %r{^expire_new_index},
            :expire_new_index,
            command: true,
            help: { "expire_new_index" => "Expire new index files in fastly." }

      def expire_new_index(response)
        p response
        cdn_client.purge_path("/names")
        cdn_client.purge_path("/versions")
        cdn_client.purge_key("info/*")
      end

      private

      def cdn_client
        @cdn_client ||= FastlyClient.new(
          config.service_id,
          config.base_url,
          config.api_key
        )
      end

      # Taken from https://github.com/bundler/bundler-api/blob/23fdde0be885d990ab14e7d7bcf309916608a489/lib/bundler_api/cache.rb
      FastlyClient = Struct.new(:service_id, :base_url, :api_key) do
        def purge_key(key)
          uri = URI("https://api.fastly.com/service/#{service_id}/purge/#{key}")
          http(uri).post uri.request_uri, nil, "Fastly-Key" => api_key
        end

        def purge_path(path)
          uri = URI("#{base_url}#{path}")
          http(uri).send_request 'PURGE', uri.path, nil, "Fastly-Key" => api_key
        end

        def http(uri)
          Net::HTTP.new(uri.host, uri.port).tap do |http|
            http.use_ssl     = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          end
        end
      end

    end
    Lita.register_handler(ExpireNewIndex)
  end
end
