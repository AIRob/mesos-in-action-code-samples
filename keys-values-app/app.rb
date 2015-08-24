require 'sinatra'
require 'redis'

set :environment, 'production'
set :bind, '0.0.0.0'
set :port, (ENV['PORT'] || 8080).to_i

# Create a new connection to Redis on $REDIS_HOST and $REDIS_PORT.
# If these aren't set, fallback to 127.0.0.1:6379.
redis_host = ENV['REDIS_HOST'] || '127.0.0.1'
redis_port = ENV['REDIS_PORT'] || 6379
redis = Redis.new(:host => redis_host, :port => redis_port)

get '/' do
  @host     = ENV['HOST'] || 'undefined'
  @port     = ENV['PORT'] || 'undefined'
  @errors   = []
  @kv_pairs = {}

  begin
    redis.ping
  rescue Exception => e
    @errors << e.message
  end

  if @errors.length == 0
    redis.keys.each do |key|
      @kv_pairs.merge!({ key => redis.get(key) })
    end
  end

  erb :index
end

post '/submit' do
  redis.set(params[:inputKey], params[:inputValue])
  redirect '/'
end
