require 'wordpress/xmlrpc'

module Wordpress
  class << self
    attr_accessor :url, :blog_id, :username, :password

    def configure
      yield self
    end
  end
end
