require 'minitest/autorun'
require 'minitest/pride'

require 'bundler/setup'
Bundler.require(:default) if defined?(Bundler)
$:.unshift(File.expand_path('../../lib', __FILE__))
