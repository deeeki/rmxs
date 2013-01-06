require 'bundler/setup'
Bundler.require(:default) if defined?(Bundler)
$:.unshift(File.expand_path('../../lib', __FILE__))

require 'yaml'
require 'bremen/ext'
require 'wordpress'
@config = YAML.load_file(File.expand_path('../../config/kyary_rmx/application.yml', __FILE__))

Wordpress.configure do |config|
  config.url = @config[:wordpress][:url]
  config.blog_id = @config[:wordpress][:blog_id]
  config.username = @config[:wordpress][:username]
  config.password = @config[:wordpress][:password]
end
Twitter.configure do |config|
  config.consumer_key = @config[:twitter][:consumer_key]
  config.consumer_secret = @config[:twitter][:consumer_secret]
  config.oauth_token = @config[:twitter][:access_token]
  config.oauth_token_secret = @config[:twitter][:access_token_secret]
end
Bremen::Soundcloud.client_id = @config[:soundcloud][:client_id]
Bremen::Validator.configure do |config|
  config.whitelist_file = File.expand_path('../../config/kyary_rmx/WHITELIST', __FILE__)
  config.blacklist_file = File.expand_path('../../config/kyary_rmx/BLACKLIST', __FILE__)
end
