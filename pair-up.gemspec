# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name = %q{pair-up}
  s.version = '1.0.2'
  s.date = Time.now.strftime('%F')
  s.license = 'MIT'

  s.description = %q{Git author attribution helper for pair programmers.}
  s.summary = %q{pair-up allows developers to be properly credited when Pair Programming and using Git.}
  s.authors = [%q{Andre Helberg}]
  s.email         = ["helberg.andre@gmail.com"]
  s.homepage = %q{http://github.com/A-Helberg/pair-up}
  s.require_paths = %w[lib]
  s.extra_rdoc_files = %w[README.md LICENSE.md]
  s.rdoc_options = [%q{--charset=UTF-8}]

  s.executables = [%q{pair}]
  s.add_development_dependency(%q<rspec>, ["~> 3.2"])
  s.add_runtime_dependency(%q<highline>, ["~> 1.6"])

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
    bin/pair
    pair-up.gemspec
    lib/pair-up.rb
    lib/pair-up/participant.rb
    lib/pair-up/pair-up.sh
    lib/pair-up/ui.rb
    spec/pair-up/participant_spec.rb
    spec/pair-up/ui_spec.rb
    spec/pair-up_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files    = s.files.grep(%r{^spec/})
end
