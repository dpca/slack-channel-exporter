require 'rubygems'
require 'bundler'

Bundler.require(:default)

Dotenv.load

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

require_relative 'lib/app'
run Exporter
