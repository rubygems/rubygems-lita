module Lita
  module Handlers
    class PruneGithubMembers < Lita::Handler
      namespace :github
      config :api_key

      route %r{^prune\sgithub\smembers\sfor\s(.+)}, :prune, command: true, help: {"prune github members for REPO" => "List members that have not contributed to REPO recently."}

      def prune(response)
        repo = response.match_data[1]
        log.debug "[prune github members] repo = #{repo.inspect}"

        # TODO: all the things

        response.reply("Here is the result: ")
      end

    end
    Lita.register_handler(PruneGithubMembers)
  end
end
