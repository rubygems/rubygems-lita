require "github_api"

module Lita
  module Handlers
    class ActiveGithubMembers < Lita::Handler
      namespace :github
      config :api_key

      route %r{^active\sgithub\smembers\sfor\s(.+)}, :active, command: true,
        help: { "list active github members for USER/REPO" => "List people who have contributed to USER/REPO in the last year." }

      def active(response)
        log.debug "[active github members] repo = #{response.match_data[1]}"
        org_name, repo_name = response.match_data[1].chomp.split("/")
        stats = RepoStats.new(org_name, repo_name)
        response.reply("Repo members who have not been active within 12 months are:\n#{stats.active_members.join("\n")}")
      end

      class RepoStats
        MIN_COMMENTS = 20
        MIN_COMMITS = 5

        attr_reader :org, :repo, :last_year

        def initialize(org, repo)
          @org, @repo = org, repo
          @last_year = (Date.today-365).to_time.iso8601
        end

        def active_contributors
          contributors = Hash.new{|h,k| h[k] = Hash.new(0) }

          committers.each do |name|
            contributors[name]["commits"] += 1
          end

          commenters.each do |name|
            contributors[name]["comments"] += 1
          end

          contributors.each do |name, info|
            if info["comments"] < MIN_COMMENTS && info["commits"] < MIN_COMMITS
              contributors.delete(name)
            end
          end

          sorted = contributors.to_a.sort_by! do |name, info|
            [-info["commits"], -info["comments"]]
          end

          sorted.map do |name, info|
            "@#{name} (#{info["commits"]} commits, #{info["comments"]} comments)"
          end
        end

        def committers
          commits.each_page do |page|
            page.each do |commit|
              yield commit["author"]["login"] if commit["author"]
            end
          end
        end

        def commenters
          comments.each_page do |page|
            page.each do |commit|
              yield commit["user"]["login"] if commit["user"].nil?
            end
          end
        end

        def commits
          Github::Client::Repos::Commits.new.all(org, repo,
            since: last_year, per_page: 100)
        end

        def comments
          Github::Client::Repos::Commits.new.all(org, repo,
            since: last_year, per_page: 100)
        end
      end
    end

    Lita.register_handler(ActiveGithubMembers)
  end
end
