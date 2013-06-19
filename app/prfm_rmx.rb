APP_NAME = 'prfm_rmx'

require File.expand_path('../../config/application', __FILE__)

SITES = ['Youtube', 'Soundcloud']

hour = Time.now.hour
case hour
when 1, 13
  site = 'Mixcloud'
when 7, 19
  site = 'Nicovideo'
else
  site = SITES[hour % 2]
end
keyword = 'Perfume'
keyword << ((hour < 12)? ' mix' : ' Remix') unless site == 'Soundcloud'
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
