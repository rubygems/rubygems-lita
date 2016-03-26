source "https://rubygems.org"

ruby '2.1.7'

gem "activesupport", "~> 4", require: "active_support/all"
gem "faraday_middleware"
gem "hashie"
gem "lita"
gem "twitter"

group :production do
  gem "lita-slack", github: 'litaio/lita-slack', branch: 'master'
end

group :development, :test do
  gem "rspec"
end
