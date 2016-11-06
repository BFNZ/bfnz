# -*- encoding: utf-8 -*-
# stub: roo 2.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "roo"
  s.version = "2.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Thomas Preymesser", "Hugh McGowan", "Ben Woosley", "Oleksandr Simonov", "Steven Daniels"]
  s.date = "2016-08-27"
  s.description = "Roo can access the contents of various spreadsheet files. It can handle\n* OpenOffice\n* Excelx\n* LibreOffice\n* CSV"
  s.email = ["ruby.ruby.ruby.roo@gmail.com", "oleksandr@simonov.me"]
  s.homepage = "http://github.com/roo-rb/roo"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Roo can access the contents of various spreadsheet files."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1"])
      s.add_runtime_dependency(%q<rubyzip>, ["< 2.0.0", "~> 1.1"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<minitest>, [">= 5.4.3", "~> 5.4"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1"])
      s.add_dependency(%q<rubyzip>, ["< 2.0.0", "~> 1.1"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<minitest>, [">= 5.4.3", "~> 5.4"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1"])
    s.add_dependency(%q<rubyzip>, ["< 2.0.0", "~> 1.1"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<minitest>, [">= 5.4.3", "~> 5.4"])
  end
end
