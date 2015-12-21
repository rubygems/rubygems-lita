module Lita
  module Handlers
    class DeployNotifications < Lita::Handler

      template_root File.expand_path("../../../../templates/deploy_notifications", __FILE__)

      on :shipit_task, :notify
      on :shipit_deploy, :notify
      on :shipit_rollback, :notify
      on :shipit_lock, :notify_lock

      DESTINATIONS = {
        'rubygems.org' => 'rubygems-org',
        'rubygems-status' => 'rubygems-org',
        'rubygems-lita' => 'rubygems-infra',
        'shipit' => 'rubygems-infra',
        'bundler-api' => 'bundler-api'
      }.freeze

      def notify(event)
        channels = channels_for(event)
        return unless channels

        message = render_template("#{event.type}_#{event.status}", event.to_h.merge(duration: duration(event)))
        channels.each do |channel|
          robot.send_message(channel, message)
        end
      rescue Lita::MissingTemplateError
        Lita.logger.debug("No template for #{event.type}_#{event.status}")
      end

      def notify_lock(event)
        channels = channels_for(event)
        return unless channels

        message = render_template(event.locked? ? 'stack_locked' : 'stack_unlocked', event.to_h)
        channels.each do |channel|
          robot.send_message(channel, message)
        end
      end

      def channels_for(event)
        channels = DESTINATIONS[event.stack.repo_name]
        return unless channels
        Array.wrap(channels).map { |c| Channels[c] }.compact
      end

      def duration(event)
        task = event[event.type]
        seconds = Time.parse(task.updated_at).to_i - Time.parse(task.created_at).to_i
        minutes = seconds / 60
        seconds = seconds % 60

        if minutes > 0
          "#{minutes}m#{seconds.to_s.rjust(2, '0')}s"
        else
          "#{seconds}s"
        end
      end
    end
    Lita.register_handler(DeployNotifications)
  end
end
