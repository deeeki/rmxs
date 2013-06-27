# coding: utf-8
module Bremen
  module Validator
    WHITELIST = [
      '作業用',
      'メドレー',
      'bgm',
    ]
    BLACKLIST = [
      '歌',
      '踊',
      'ってみた',
      'album',
      'pv',
      'mv',
      'avi',
      'wmv',
      'cover',
      'カバー',
    ]

    class << self
      attr_writer :whitelist_file, :blacklist_file
      def configure
        yield self
      end

      def whitelist
        raise "must be set #{name}.whitelist_file" unless @whitelist_file
        @whitelist ||= IO.read(@whitelist_file).split("\n") + WHITELIST
      end

      def blacklist
        raise "must be set #{name}.blacklist_file" unless @blacklist_file
        @blacklist ||= IO.read(@blacklist_file).split("\n") + BLACKLIST
      end
    end

    def allowable?
      downcased_title = title.to_s.downcase
      Validator.whitelist.each do |word|
        return true if downcased_title.include?(word)
      end
      false
    end

    def deniable?
      downcased_title = title.to_s.downcase
      Validator.blacklist.each do |word|
        return true if downcased_title.include?(word)
      end
      false
    end
  end
end
