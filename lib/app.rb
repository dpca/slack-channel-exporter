require 'sinatra/base'

require_relative './slack_helpers'

class Exporter < Sinatra::Base
  set :views, settings.root + '/../views'
  set :haml, format: :html5

  get '/' do
    @defaults = if ENV['DEFAULT_CHANNELS']
                  [ENV['DEFAULT_CHANNELS']] + ENV['DEFAULT_CHANNELS'].split(' ')
                else
                  []
                end
    haml :index
  end

  get '/export' do
    begin
      if params[:channel]
        @member_groups = params[:channel].split(' ').each_with_object({}) do |channel, h|
          h[channel] = SlackHelpers.channel_members(Slack::Web::Client.new, channel)
        end
        haml :export
      else
        haml :error, locals: { error: 'No channel provided!' }
      end
    rescue Slack::Web::Api::Error => e
      haml :error, locals: { error: e }
    end
  end
end
