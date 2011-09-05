require File.expand_path("../lib/hitch/version", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{hitch}
  s.version = Hitch::VERSION
  s.platform = Gem::Platform::RUBY

  s.required_rubygems_version = ">= 1.3.6"
  s.authors = [%q{Rogelio J. Samour}]
  s.date = Time.now.strftime('%F')
  s.email = %q{rogelio@therubymug.com}
  s.executables = [%q{hitch}]
  s.files = Dir["{lib}/**/*.rb", "bin/*", "Rakefile", "*.md"]
  s.homepage = %q{http://github.com/therubymug/hitch}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.description = %q{Git author attribution helper for pair programmers.}
  s.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
  s.test_files = Dir["{spec}/**/*.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_runtime_dependency(%q<highline>, [">= 1.6.2"])
    else
      s.add_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_dependency(%q<highline>, [">= 1.6.2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.6.0"])
    s.add_dependency(%q<highline>, [">= 1.6.2"])
  end
end
