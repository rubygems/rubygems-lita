# rubygems-lita

Welcome! This is the Lita chat bot that is in Bundler and RubyGems' Slack rooms. You can use it to deploy, tweet, and do many other interesting things.

Make sure you set the follow ENV variables:

| Variable                    | Data           |
| ----------------------------|:--------------:|
| ENVIRONMENT                 | Set to production to use the Slack adapter, otherwise shell adapter will be used |
| SLACK_TOKEN                 | Token from Slack's integrations dashboard |
| REDISTOGO_URL               | Will be automatically set if you enable the RedisToGo addon on Heroku |
| SHIPIT_TOKEN                | Shipit API client token |
| TWITTER_CONSUMER_KEY        | Twitter's consumer key for 'rubygems-status' |
| TWITTER_CONSUMER_SECRET     | Twitter's consumer secret for 'rubygems-status' |
| TWITTER_ACCESS_TOKEN        | Twitter's access token for 'rubygems-status' |
| TWITTER_ACCESS_TOKEN_SECRET | Twitter's access token secret for 'rubygems-status' |
