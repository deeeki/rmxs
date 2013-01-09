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
        [Wordpress.blog_id, Wordpress.username, Wordpress.password]
      end

      def get_post post_id, fields = []
        args = [post_id]
        args << fields unless fields.empty?
        client.call('wp.getPost', (base_args + args))
      end

      def get_posts filter = {}, fields = []
        args = [filter]
        args << fields unless fields.empty?
        client.call('wp.getPosts', (base_args + args))
      end

      def get_uids category = nil
        client.call('wp.getUids', (base_args + [category]).compact)
      end

      def new_post content
        client.call('wp.newPost', (base_args + [content]))
      end

      def edit_post post_id, content
        client.call('wp.editPost', (base_args + [post_id, content]))
      end

      def delete_post post_id
        client.call('wp.deletePost', (base_args + [post_id]))
      end
    end
  end
end
