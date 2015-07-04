require 'sinatra'

set :environment, 'production'
set :bind, '0.0.0.0'
set :port, (ENV['PORT'] || 8080).to_i

get '/' do
  @environment = ENV
  erb :index
end
