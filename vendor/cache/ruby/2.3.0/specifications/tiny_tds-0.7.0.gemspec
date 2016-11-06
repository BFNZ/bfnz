# -*- encoding: utf-8 -*-
# stub: tiny_tds 0.7.0 ruby lib
# stub: ext/tiny_tds/extconf.rb

Gem::Specification.new do |s|
  s.name = "tiny_tds"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ken Collins", "Erik Bryn", "Will Bond"]
  s.date = "2015-08-09"
  s.description = "TinyTDS - A modern, simple and fast FreeTDS library for Ruby using DB-Library. Developed for the ActiveRecord SQL Server adapter."
  s.email = ["ken@metaskills.net", "will@wbond.net"]
  s.extensions = ["ext/tiny_tds/extconf.rb"]
  s.files = ["ext/tiny_tds/extconf.rb"]
  s.homepage = "http://github.com/rails-sqlserver/tiny_tds"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.5.1"
  s.summary = "TinyTDS - A modern, simple and fast FreeTDS library for Ruby using DB-Library."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mini_portile>, ["= 0.6.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.4"])
      s.add_development_dependency(%q<rake-compiler>, ["= 0.9.5"])
      s.add_development_dependency(%q<rake-compiler-dock>, ["~> 0.4.3"])
      s.add_development_dependency(%q<minitest>, ["~> 5.6"])
      s.add_development_dependency(%q<connection_pool>, ["~> 2.2"])
    else
      s.add_dependency(%q<mini_portile>, ["= 0.6.2"])
      s.add_dependency(%q<rake>, ["~> 10.4"])
      s.add_dependency(%q<rake-compiler>, ["= 0.9.5"])
      s.add_dependency(%q<rake-compiler-dock>, ["~> 0.4.3"])
      s.add_dependency(%q<minitest>, ["~> 5.6"])
      s.add_dependency(%q<connection_pool>, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<mini_portile>, ["= 0.6.2"])
    s.add_dependency(%q<rake>, ["~> 10.4"])
    s.add_dependency(%q<rake-compiler>, ["= 0.9.5"])
    s.add_dependency(%q<rake-compiler-dock>, ["~> 0.4.3"])
    s.add_dependency(%q<minitest>, ["~> 5.6"])
    s.add_dependency(%q<connection_pool>, ["~> 2.2"])
  end
end
