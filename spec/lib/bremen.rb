# coding: utf-8
$:.unshift(File.expand_path('../../', __FILE__))
require 'spec_helper'

require 'bremen/ext'

Bremen::Validator.configure do |config|
  config.whitelist_file = File.expand_path('../../fixtures/WHITELIST', __FILE__)
  config.blacklist_file = File.expand_path('../../fixtures/BLACKLIST', __FILE__)
end

describe Bremen::Validator do
  let(:track){ Bremen::Youtube.new(attrs) }
  describe 'allowable?' do
    subject{ track.allowable? }

    describe 'allowable case' do
      describe 'title includes listed word from class' do
        let(:attrs){ { title: 'BGM track' } }
        it('allow'){ subject.must_equal true }
      end
      describe 'title includes listed word from file' do
        let(:attrs){ { title: 'ok_title track' } }
        it('allow'){ subject.must_equal true }
      end
    end

    describe 'not allowable case' do
      let(:attrs){ { title: 'not listed words' } }
      it('not allow'){ subject.must_equal false }
    end
  end

  describe 'deniable?' do
    subject{ track.deniable? }

    describe 'deniable case' do
      describe 'title includes listed word from class' do
        let(:attrs){ { title: 'Track 歌ってみた' } }
        it('deny'){ subject.must_equal true }
      end

      describe 'title includes listed word from file' do
        let(:attrs){ { title: 'ng_title track' } }
        it('deny'){ subject.must_equal true }
      end
    end

    describe 'not deniable case' do
      let(:attrs){ { title: 'not listed words' } }
      it('not deny'){ subject.must_equal false }
    end
  end
end
