begin
  require 'jeweler'
  require 'lib/hitch'
  require 'fileutils'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = %q{hitch}
    gemspec.version = Hitch::VERSION
    gemspec.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
    gemspec.email = %q{rogelio@therubymug.com}
    gemspec.homepage = %q{http://github.com/therubymug/hitch}
    gemspec.has_rdoc = false
    gemspec.authors = ["Rogelio Samour", "Les Hill"]
    gemspec.files = %w( README.rdoc Rakefile ) + Dir["{bin,lib}/**/*"].sort
    gemspec.extra_rdoc_files = ["README.rdoc"]
    gemspec.executables = ["hitch", "unhitch", "hitchrc"]
    gemspec.add_dependency('highline', '>= 1.5.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
