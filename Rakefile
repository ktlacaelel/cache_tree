# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cache_tree"
  gem.homepage = "http://github.com/ktlacaelel/cache_tree"
  gem.license = "MIT"
  gem.summary = %Q{Simple cache tree}
  gem.description = %Q{Cache based on btrees, for large ammounts of cache.}
  gem.email = "kazu.dev@gmail.com"
  gem.authors = ["kazuyoshi tlacaelel"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

