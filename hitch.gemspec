# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hitch}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rogelio Samour", "Les Hill"]
  s.date = %q{2009-04-20}
  s.email = %q{ro@hashrocket.com}
  s.executables = ["hitch", "unhitch", "hitchrc"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/hitch", "bin/hitchrc", "bin/unhitch", "lib/hitch.rb"]
  s.homepage = %q{http://github.com/therubymug/hitch}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.0"])
  end
end
