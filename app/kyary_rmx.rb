# coding: utf-8
require File.expand_path('../../config/kyary_rmx', __FILE__)

SITES = ['Youtube', 'Nicovideo', 'Soundcloud', 'Mixcloud']

hour = Time.now.hour
site = SITES[hour % 4]
keyword = (hour < 12)? 'kyary mix' : 'きゃりー mix'
klass = Bremen.const_get(site)

uids = Wordpress::Xmlrpc.get_uids(klass.name.split('::').last)

tracks = klass.search(keyword: keyword, limit: 50)
exit if tracks.empty?

tracks.reverse.each do |track|
  next if uids.include?(track.uid.to_s)

  post = track.to_wordpress_post
  id = Wordpress::Xmlrpc.new_post(post)

  if track.deniable? && (track.allowable? || site == 'Nicovideo')
    status = track.to_twitter_status(hashtag: '#KyaryPamyuPamyu')
    Twitter.update(status)
  end

  break
end
