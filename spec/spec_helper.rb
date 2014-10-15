GEM_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib')

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end

require 'xctools'
