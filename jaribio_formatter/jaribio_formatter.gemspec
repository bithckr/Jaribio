# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jaribio/formatter/version"

Gem::Specification.new do |s|
  s.name = "jaribio_formatter"
  s.version = Jaribio::Formatter::VERSION
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.authors = ["C. Brian Jones"]
  s.email = "cbjones1@gmail.com"
  s.homepage = "https://github.com/bithckr/Jaribio/tree/master/jaribio_formatter"
  s.license = "MIT"
  s.summary = %Q{Jaribio test framework formatters}
  s.description = %Q{Provide the necessary code to record execution results in Jaribio while running tests in RSpec}
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.rdoc Rakefile jaribio_formatter.gemspec)
  s.test_files = Dir.glob("{spec}/**/*")
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.8.10"

  s.add_runtime_dependency 'activeresource', '~> 3.1.1'

  s.add_development_dependency 'rake', '~> 0.9.2.2'
  s.add_development_dependency 'rdoc', '3.12'
  s.add_development_dependency 'rspec', '~> 2.8.0'
end
