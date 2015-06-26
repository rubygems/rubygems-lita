# rubygems-lita

Welcome! This is the Lita chat bot that is in Bundler and RubyGems' Slack rooms. You can use it to deploy, tweet, and do many other interesting things.

Make sure you set the follow ENV variables:

| Variable                    | Data           |
| ----------------------------|:--------------:|
| ENVIRONMENT                 | Set to production to use the Slack adapter, otherwise shell adapter will be used |
| SLACK_TOKEN                 | Token from Slack's integrations dashboard |
| REDISTOGO_URL               | Will be automatically set if you enable the RedisToGo addon on Heroku |
| SHIPIT_TOKEN                | Shipit API client token |
| TWITTER_CONSUMER_KEY        | Twitter consumer key |
| TWITTER_CONSUMER_SECRET     | Twitter consumer secret |
| TWITTER_ACCOUNTS            | Hash of Twitter accounts and access tokens |
