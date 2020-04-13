# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.license = "MIT"
  s.name = %q{hitch}
  s.version = '1.1.0'
  s.date = Time.now.strftime('%F')

  s.description = %q{Git author attribution helper for pair programmers.}
  s.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
  s.authors = [%q{Rogelio J. Samour}]
  s.email         = ["rogelio@therubymug.com"]
  s.homepage = %q{http://github.com/therubymug/hitch}
  s.require_paths = %w[lib]
  s.extra_rdoc_files = %w[README.md LICENSE.md]
  s.rdoc_options = [%q{--charset=UTF-8}]

  s.executables = [%q{hitch}]
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

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    LICENSE.md
    README.md
    Rakefile
    bin/hitch
    hitch.gemspec
    lib/hitch.rb
    lib/hitch/author.rb
    lib/hitch/hitch.sh
    lib/hitch/ui.rb
    spec/acceptance/hitch_spec.rb
    spec/hitch/author_spec.rb
    spec/hitch/ui_spec.rb
    spec/hitch_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files    = s.files.grep(%r{^spec/})
end
