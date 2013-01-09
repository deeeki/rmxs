require 'bremen/validator'

module Bremen
  class Base
    include Validator

    def to_wordpress_post options = {}
      {
        post_type: 'post',
        post_status: deniable? ? 'draft' : allowable? ? 'publish' : 'pending',
        post_title: title,
        post_author: 0,
        post_excerpt: url,
        post_content: content,
        post_date_gmt: Time.now.utc,
        post_format: 'standard',
        post_name: uid,
        post_password: '',
        post_content_filtered: uid,
        comment_status: 'open',
        ping_status: 'open',
        sticky: false,
        #post_thumbnail: '',
        #post_parent: '',
        custom_fields: [
          {key: 'seconds', value: length},
          {key: 'thumbnail_url', value: thumbnail_url || ''},
        ],
        #terms: [],
        terms_names: {
          category: [self.class.name.split('::').last],
        },
        enclosure: {},
      }.merge(options)
    end

    def to_twitter_status options = {}
      prefix = (created_at > (Time.now - 604800)) ? '*New!* ' : ''
      author = (self.author && self.author.name) ? "by #{self.author.name} " : ''
      released_on = created_at.strftime('%Y-%m-%d')
      hashtag = (allowable? && !deniable?) ? options[:hashtag] || '' : ''
      url_length = (url =~ /^https:/) ? 23 : 22
      title_max_length = 140 - (prefix + author + released_on + hashtag).size - url_length - 4
      title = self.title
      title = title[0, title_max_length - 4] + ' ...' if title.size > title_max_length

      "#{prefix}#{title} #{url} (#{author}#{released_on}) #{hashtag}"
    end

    def released_at
      created_at.strftime('%Y-%m-%d %H:%M')
    end
  end

  class Youtube
    def embed options = {}
      width = options.delete(:width) || 640
      height = options.delete(:height) || 360
      query = self.class.build_query({rel: 0, showinfo: 0}.merge(options))
      %Q(<iframe width="#{width}" height="#{height}" src="http://www.youtube.com/embed/#{uid}?#{query}" frameborder="0" allowfullscreen></iframe>)
    end

    def content
      <<-CONTENT
#{embed}
<a href="#{url}">#{title}</a>
by <a href="#{author.url}">#{author.name}</a><br />
Released at #{released_at}
      CONTENT
    end
  end

  class Nicovideo
    def embed options = {}
      query = self.class.build_query({w: 640, h: 360}.merge(options))
      %Q(<script type="text/javascript" src="http://ext.nicovideo.jp/thumb_watch/#{uid}?#{query}"></script><noscript><a href="http://www.nicovideo.jp/watch/#{uid}">#{title}</a></noscript>)
    end

    def content
      <<-CONTENT
#{embed}
<iframe width="312" height="176" src="http://ext.nicovideo.jp/thumb/#{uid}" scrolling="no" style="border:solid 1px #CCC;" frameborder="0">
<a href="http://www.nicovideo.jp/watch/#{uid}">#{title}</a></iframe>
<a href="#{url}">#{title}</a><br />
Released at #{released_at}<br />
      CONTENT
    end
  end

  class Soundcloud
    def embed options = {}
      %Q(<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F#{uid}&amp;auto_play=false&amp;show_artwork=true&amp;color=ff7700"></iframe>)
    end

    def content
      <<-CONTENT
#{embed}
<a href="#{url}">#{title}</a>
by <a href="#{author.url}">#{author.name}</a><br />
Released at #{released_at}
      CONTENT
    end
  end

  class Mixcloud
    def embed options = {}
      %Q(<iframe width="100%" height="480" src="//www.mixcloud.com/widget/iframe/?feed=#{CGI.escape(url)}&stylecolor=&embed_type=widget_standard" frameborder="0"></iframe>)
    end

    def content
      <<-CONTENT
#{embed}
<div style="clear:both; height:3px; width:auto;"></div><p style="display:block; font-size:12px; font-family:Helvetica, Arial, sans-serif; margin:0; padding: 3px 4px; color:#02a0c7; width:auto;"><a href="#{url}?utm_source=widget&amp;utm_medium=web&amp;utm_campaign=base_links&amp;utm_term=resource_link" target="_blank" style="color:#02a0c7; font-weight:bold;">#{title}</a><span> by </span><a href="#{author.url}?utm_source=widget&amp;utm_medium=web&amp;utm_campaign=base_links&amp;utm_term=profile_link" target="_blank" style="color:#02a0c7; font-weight:bold;">#{author.name}</a><span> on </span><a href="http://www.mixcloud.com/?utm_source=widget&utm_medium=web&utm_campaign=base_links&utm_term=homepage_link" target="_blank" style="color:#02a0c7; font-weight:bold;"> Mixcloud</a></p><div style="clear:both; height:3px;"></div>
Released at #{released_at}<br />
      CONTENT
    end
  end
end
