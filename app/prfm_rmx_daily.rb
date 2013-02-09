# coding: utf-8
require File.expand_path('../../config/prfm_rmx', __FILE__)

yesterday = Time.now.utc - 60 * 60 * 24
posts = Wordpress::Xmlrpc.get_posts
count = posts.reject{|p| p['post_status'] != 'publish' || p['post_date_gmt'].to_time <= yesterday }.count

if count > 0
  status = %[【まとめ】本日(#{Time.now.strftime('%-m/%-d')})はRemix音源が#{count} 件みつかりました！ http://is.gd/prfm_rmx #prfm]
else
  status = %[【まとめ】本日(#{Time.now.strftime('%-m/%-d')})はRemix音源がみつかりませんでした＞＜ http://is.gd/prfm_rmx]
end

Twitter.update(status)

REGEXP = /Perfume|prfm|ぱふゅ|パフュ|ﾊﾟﾌｭ|あ(ー|〜)ちゃん|のっち|かしゆか|ヤスタカ|ﾔｽﾀｶ|ystk/i
follower_ids = Twitter.follower_ids.ids[0..9]
Twitter.users(follower_ids).each do |user|
  if user.name =~ REGEXP || user.description =~ REGEXP
    Twitter.follow!(user)
  end
end
