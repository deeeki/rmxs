# coding: utf-8
unless APP_NAME = ARGV.first
  $stderr.puts 'ERROR: need to exec with app name (ARGV)'
  exit
end
require File.expand_path("../../config/application", __FILE__)

SITES = ['Youtube', 'Nicovideo', 'Soundcloud', 'Mixcloud']

max_id = Wordpress::Xmlrpc.get_posts({}, ['post_id']).first['post_id'].to_i

(1..max_id).each do |id|
  begin
    post = Wordpress::Xmlrpc.get_post(id)
  rescue XMLRPC::FaultException
    next
  end
  next unless post['post_excerpt'].empty?
  category = post['terms'].select{|t| t['taxonomy'] == 'category'}.first
  next unless category
  site = category['name'].capitalize
  next unless SITES.include?(site)
  url = post['post_content'].scan(/<a href="([^"]+)">.+?<\/a><br /).flatten.first
  klass = Bremen.const_get(site)
  begin
    track = klass.find(url)
  rescue OpenURI::HTTPError => e
    if ['403 Forbidden', '404 Not Found'].include?(e.to_s)
      Wordpress::Xmlrpc.delete_post(id)
      next
    else
      p id, url
      raise e
    end
  rescue => e
    if e.to_s.include?('redirection forbidden')
      Wordpress::Xmlrpc.delete_post(id)
      next
    else
      p id, url
      raise e
    end
  end
  content = track.to_wordpress_post
  content[:post_status] = post['post_status']
  content.delete(:post_date_gmt)
  Wordpress::Xmlrpc.edit_post(id, content)
end
