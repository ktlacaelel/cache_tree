# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: cache_tree 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "cache_tree"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["kazuyoshi tlacaelel"]
  s.date = "2015-05-26"
  s.description = "Cache based on btrees, for large ammounts of cache."
  s.email = "kazu.dev@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "cache_tree.gemspec",
    "lib/cache_tree.rb",
    "test/helper.rb",
    "test/test_cache_tree.rb"
  ]
  s.homepage = "http://github.com/ktlacaelel/cache_tree"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.3"
  s.summary = "Simple cache tree"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<isna>, [">= 0"])
      s.add_runtime_dependency(%q<tree_node>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<isna>, [">= 0"])
      s.add_dependency(%q<tree_node>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<isna>, [">= 0"])
    s.add_dependency(%q<tree_node>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end

