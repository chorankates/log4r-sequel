# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: log4r-sequel 0.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "log4r-sequel"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Conor Horan-Kates"]
  s.date = "2016-09-14"
  s.description = "Log4r::Outputter that writes to a Sequel database"
  s.email = ["conor.code@gmail.com"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "VERSION",
    "example/log2postgres.rb",
    "example/log2sqlite.rb",
    "example/log4r-postgres.yaml",
    "example/log4r-sqlite.yaml",
    "lib/log4r/outputter/sequeloutputter.rb",
    "test/functional/test_postgres.rb",
    "test/functional/test_sqlite.rb",
    "test/log4r-postgres_test.yaml",
    "test/log4r-sqlite_test.yaml"
  ]
  s.homepage = "http://github.com/chorankates/log4r-sequel"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Log4r::Outputter::Sequel"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<log4r>, ["> 1.1", "~> 1.1.9"])
      s.add_runtime_dependency(%q<rack>, ["= 1.6.4"])
      s.add_runtime_dependency(%q<sequel>, [">= 4.6.0", "~> 4.6"])
      s.add_runtime_dependency(%q<hoe>, [">= 3.15.1", "~> 3.15"])
      s.add_development_dependency(%q<jeweler>, [">= 2.0.0", "~> 2.0"])
      s.add_development_dependency(%q<test-unit>, [">= 2.0.0", "~> 2.0"])
    else
      s.add_dependency(%q<log4r>, ["> 1.1", "~> 1.1.9"])
      s.add_dependency(%q<rack>, ["= 1.6.4"])
      s.add_dependency(%q<sequel>, [">= 4.6.0", "~> 4.6"])
      s.add_dependency(%q<hoe>, [">= 3.15.1", "~> 3.15"])
      s.add_dependency(%q<jeweler>, [">= 2.0.0", "~> 2.0"])
      s.add_dependency(%q<test-unit>, [">= 2.0.0", "~> 2.0"])
    end
  else
    s.add_dependency(%q<log4r>, ["> 1.1", "~> 1.1.9"])
    s.add_dependency(%q<rack>, ["= 1.6.4"])
    s.add_dependency(%q<sequel>, [">= 4.6.0", "~> 4.6"])
    s.add_dependency(%q<hoe>, [">= 3.15.1", "~> 3.15"])
    s.add_dependency(%q<jeweler>, [">= 2.0.0", "~> 2.0"])
    s.add_dependency(%q<test-unit>, [">= 2.0.0", "~> 2.0"])
  end
end

