# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'event_lawyer/version'

Gem::Specification.new do |s|
  s.name        = "event_lawyer"
  s.version     = EventLawyer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Stitch Fix Engineering']
  s.email       = ['eng@stitchfix.com']
  s.homepage    = "http://www.stitchfix.com"
  s.summary     = "My awesome new gem"
  s.description = "My awesome new gem"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("pwwka")
  s.add_dependency("activesupport")
  s.add_dependency("awesome_print")
  s.add_dependency("json-schema")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
end
