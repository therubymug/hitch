Gem::Specification.new do |s|
  s.name = %q{hitch}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rogelio J. Samour"]
  s.date = %q{2010-10-10}
  s.default_executable = %q{hitch}
  s.email = %q{rogelio@therubymug.com}
  s.executables = ["hitch"]
  s.files = [
    "Rakefile",
     "bin/hitch",
     "lib/hitch.rb",
     "lib/hitch/author.rb",
     "lib/hitch/ui.rb"
  ]
  s.homepage = %q{http://github.com/therubymug/hitch}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
  s.test_files = [
    "spec/helper.rb",
     "spec/hitch/author_spec.rb",
     "spec/hitch/ui_spec.rb",
     "spec/hitch_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<highline>, [">= 1.5.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<highline>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<highline>, [">= 1.5.0"])
  end
end

