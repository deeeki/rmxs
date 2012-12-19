# coding: utf-8
require File.expand_path('../../config/kyary_rmx', __FILE__)

SITES = ['Youtube', 'Nicovideo', 'Soundcloud']
LOG = File.expand_path('../../log/kyary_rmx.yml', __FILE__)
IO.write(LOG, YAML.dump(Hash[SITES.map{|s| [s, 1]}])) unless File.exist?(LOG)

progress = YAML.load_file(LOG)

site = progress.delete_if{|k,v| v.zero? }.keys.sample
keyword = (site == 'Soundcloud') ? 'kyary mix' : 'きゃりー mix'
page = progress[site]
klass = Bremen.const_get(site)

uids = Wordpress::Xmlrpc.get_uids(klass.name.split('::').last)

tracks = klass.search(keyword: keyword, limit: 50, page: page)
if tracks.empty?
  progress[site] = 0
  IO.write(LOG, YAML.dump(progress))
  exit
end

tracks.each_with_index do |track, i|
  next if uids.include?(track.uid.to_s)

  post = track.to_wordpress_post
  id = Wordpress::Xmlrpc.new_post(post)

  unless track.deniable?
    status = track.to_twitter_status
    Twitter.update(status)
  end

  if i == tracks.size - 1
    progress[site] += 1
    IO.write(LOG, YAML.dump(progress))
  end

  break
end
