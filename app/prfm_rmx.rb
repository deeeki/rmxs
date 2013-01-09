# coding: utf-8
require File.expand_path('../../config/prfm_rmx', __FILE__)

SITES = ['Youtube', 'Nicovideo', 'Soundcloud', 'Mixcloud']

hour = Time.now.hour
site = SITES[hour % 4]
keyword = (hour < 12)? 'Perfume mix' : 'Perfume rmx'
klass = Bremen.const_get(site)

uids = Wordpress::Xmlrpc.get_uids(klass.name.split('::').last)

tracks = klass.search(keyword: keyword, limit: 50)
exit if tracks.empty?

tracks.reverse.each do |track|
  next if uids.include?(track.uid.to_s)

  post = track.to_wordpress_post
  id = Wordpress::Xmlrpc.new_post(post)

  unless track.deniable?
    status = track.to_twitter_status(hashtag: '#prfm')
    Twitter.update(status)
  end

  break
end
