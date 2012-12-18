require 'uri'
require 'xmlrpc/client'

module Wordpress
  class Xmlrpc
    class << self
      def uri
        @uri ||= URI.parse("#{Wordpress.url.chomp('/')}/xmlrpc.php")
      end

      def client
        @client ||= XMLRPC::Client.new(uri.host, uri.path, uri.port)
      end

      def base_args
        @base_args ||= [Wordpress.url, Wordpress.blog_id, Wordpress.password]
      end

      def get_post post_id, fields = []
        args = [post_id]
        args << fields unless fields.empty?
        client.call('wp.getPost', base_args.concat(args))
      end

      def get_recent_posts limit = 20
        client.call('wp.getRecentPosts', base_args.concat([limit]))
      end

      def get_uids category = nil
        client.call('wp.getUids', base_args.concat([category]).compact)
      end

      def new_post struct
        client.call('wp.newPost', base_args.concat([struct]))
      end
    end
  end
end
