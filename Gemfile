source "https://rubygems.org"

ruby '2.1.6'

gem "activesupport", "~> 4", require: "active_support/all"
gem "faraday_middleware"
gem "hashie"
gem "lita"
gem "lita-twitter-status"

group :production do
  gem "lita-slack"
end

group :development, :test do
  gem "rspec"
end
