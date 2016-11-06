# -*- encoding: utf-8 -*-
# stub: authlogic 3.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "authlogic"
  s.version = "3.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ben Johnson"]
  s.date = "2016-08-29"
  s.description = "A clean, simple, and unobtrusive ruby authentication solution."
  s.email = ["bjohnson@binarylogic.com"]
  s.homepage = "http://github.com/binarylogic/authlogic"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A clean, simple, and unobtrusive ruby authentication solution."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 5.1", ">= 3.2"])
      s.add_runtime_dependency(%q<activesupport>, ["< 5.1", ">= 3.2"])
      s.add_runtime_dependency(%q<request_store>, ["~> 1.0"])
      s.add_runtime_dependency(%q<scrypt>, ["< 4.0", ">= 1.2"])
      s.add_development_dependency(%q<bcrypt>, ["~> 3.1"])
      s.add_development_dependency(%q<timecop>, ["~> 0.7"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.41.2"])
    else
      s.add_dependency(%q<activerecord>, ["< 5.1", ">= 3.2"])
      s.add_dependency(%q<activesupport>, ["< 5.1", ">= 3.2"])
      s.add_dependency(%q<request_store>, ["~> 1.0"])
      s.add_dependency(%q<scrypt>, ["< 4.0", ">= 1.2"])
      s.add_dependency(%q<bcrypt>, ["~> 3.1"])
      s.add_dependency(%q<timecop>, ["~> 0.7"])
      s.add_dependency(%q<rubocop>, ["~> 0.41.2"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 5.1", ">= 3.2"])
    s.add_dependency(%q<activesupport>, ["< 5.1", ">= 3.2"])
    s.add_dependency(%q<request_store>, ["~> 1.0"])
    s.add_dependency(%q<scrypt>, ["< 4.0", ">= 1.2"])
    s.add_dependency(%q<bcrypt>, ["~> 3.1"])
    s.add_dependency(%q<timecop>, ["~> 0.7"])
    s.add_dependency(%q<rubocop>, ["~> 0.41.2"])
  end
end
