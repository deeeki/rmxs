APP_NAME = 'prfm_rmx'

require File.expand_path('../../config/application', __FILE__)

SITES = ['Youtube', 'Nicovideo', 'Soundcloud']

hour = Time.now.hour
site = (hour == 8)? 'Mixcloud' : SITES[hour % 3]
keyword = %[Perfume #{(hour < 12)? 'mix' : 'Remix'}]
klass = Bremen.const_get(site)

uids = Wordpress::Xmlrpc.get_uids(site)

tracks = klass.search(keyword: keyword, limit: 50)
exit if tracks.empty?

tracks.reverse.each do |track|
  next if uids.include?(track.uid.to_s)

  post = track.to_wordpress_post
  id = Wordpress::Xmlrpc.new_post(post)

  if !track.deniable? && (track.allowable? || site == 'Nicovideo')
    status = track.to_twitter_status(hashtag: '#prfm')
    Twitter.update(status)
  end

  break
end
