require "simplecov"
SimpleCov.start
GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
Dir["#{GEM_ROOT}/spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.order = "random"
end
