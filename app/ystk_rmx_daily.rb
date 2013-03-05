# coding: utf-8
APP_NAME = 'ystk_rmx'

require File.expand_path('../../config/application', __FILE__)

yesterday = Time.now.utc - 60 * 60 * 24
posts = Wordpress::Xmlrpc.get_posts
count = posts.reject{|p| p['post_status'] != 'publish' || p['post_date_gmt'].to_time <= yesterday }.count

if count > 0
  status = %[【まとめ】本日(#{Time.now.strftime('%-m/%-d')})はRemix音源を#{count} 件みつけた！ http://j.mp/ystk_rmx #ystk]
else
  status = %[【まとめ】本日(#{Time.now.strftime('%-m/%-d')})はRemix音源をみつけられず… http://j.mp/ystk_rmx]
end

Twitter.update(status)

REGEXP = /ヤスタカ|ﾔｽﾀｶ|ystk|capsule|こしじまとしこ|こしこ|MEG|きゃりー|Perfume|prfm|ぱふゅ|パフュ|ﾊﾟﾌｭ|/i
follower_ids = Twitter.follower_ids.ids[0..9]
Twitter.users(follower_ids).each do |user|
  if user.name =~ REGEXP || user.description =~ REGEXP
    Twitter.follow!(user)
  end
end
