# -*- encoding: utf-8 -*-
# stub: rake-compiler 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rake-compiler"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.23") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kouhei Sutou", "Luis Lavena"]
  s.date = "2016-06-20"
  s.description = "Provide a standard and simplified way to build and package\nRuby extensions (C, Java) using Rake as glue."
  s.email = ["kou@cozmixng.org", "luislavena@gmail.com"]
  s.executables = ["rake-compiler"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt", "History.txt"]
  s.files = ["History.txt", "LICENSE.txt", "README.rdoc", "bin/rake-compiler"]
  s.homepage = "https://github.com/rake-compiler/rake-compiler"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "rake-compiler -- Documentation"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "rake-compiler"
  s.rubygems_version = "2.5.1"
  s.summary = "Rake-based Ruby Extension (C, Java) task generator."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.1.4"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<cucumber>, ["~> 1.1.4"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<cucumber>, ["~> 1.1.4"])
  end
end
