#require 'resque/server'
#rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
#redis_config = YAML.load_file(rails_root + '/config/redis.yml')
#Resque.redis = redis_config[Rails.env]
#Resque::Server.use Rack::Auth::Basic do |username, password|
#  username == "priyank"
#  password == "priyank"
#end

