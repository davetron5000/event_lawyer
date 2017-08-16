require 'rubygems/package_task'
require 'rspec/core/rake_task'
require "pwwka/tasks"

$: << File.join(File.dirname(__FILE__),'lib')

include Rake::DSL

gemspec = eval(File.read('event_lawyer.gemspec'))
Gem::PackageTask.new(gemspec) {}
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task "producer:verify" do
  sh "bin/rspec spec/producer"
end

task "consumers:verify" do
  sh "bin/rspec spec/consumer"
end
