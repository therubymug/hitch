require 'spec/rake/spectask'

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-ps --color)
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = %q{hitch}
    gemspec.version = '0.6.1'
    gemspec.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
    gemspec.email = %q{rogelio@therubymug.com}
    gemspec.homepage = %q{http://github.com/therubymug/hitch}
    gemspec.has_rdoc = false
    gemspec.authors = ["Rogelio J. Samour"]
    gemspec.files = %w( README.rdoc Rakefile ) + Dir["{bin,lib}/**/*"].sort
    gemspec.extra_rdoc_files = ["README.rdoc"]
    gemspec.executables = ["hitch"]
    gemspec.add_development_dependency "rspec", ">= 1.3.0"
    gemspec.add_dependency('highline', '>= 1.5.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
