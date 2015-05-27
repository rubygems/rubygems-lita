require 'json'
require 'hashie/mash'

module Lita
  module Handlers
    class ShipitNotifications < Lita::Handler
      http.post "/webhooks/shipit", :dispatch

      def dispatch(request, response)
        event_type = request.env['HTTP_X_SHIPSTER_EVENT'] || request.env['HTTP_X_SHIPIT_EVENT']
        payload = JSON.parse(request.body.read)
        payload['type'] = event_type
        payload = Hashie::Mash.new(payload)

        response.close

        robot.trigger(:"shipit_#{payload.type}", payload)
        robot.trigger(:shipit, payload)
      end
    end

    Lita.register_handler(ShipitNotifications)
  end
end
