module Bremen
  module Validator
    class << self
      attr_writer :whitelist_file, :blacklist_file

      def configure
        yield self
      end

      def whitelist
        raise "must be set #{name}.whitelist_file" unless @whitelist_file
        @whitelist ||= IO.read(@whitelist_file).split("\n")
      end

      def blacklist
        raise "must be set #{name}.blacklist_file" unless @blacklist_file
        @blacklist ||= IO.read(@blacklist_file).split("\n")
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
