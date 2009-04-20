# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'hitch'

task :default => 'spec:run'

PROJ.name = 'hitch'
PROJ.authors = 'Rogelio J. Samour (therubymug)'
PROJ.email = 'rogelio@therubymug.com'
PROJ.url = 'http://github.com/therubymug/hitch'
PROJ.version = Hitch::VERSION
PROJ.rubyforge.name = 'hitch'
PROJ.dependencies = ['highline']

PROJ.spec.opts << '--color'

require 'fileutils'

spec = Gem::Specification.new do |s|
  s.name = %q{hitch}
  s.version = "0.0.2"
  s.summary = %q{Hitch allows developers to be properly credited when Pair Programming and using Git.}
  s.email = %q{ro@hashrocket.com}
  s.homepage = %q{http://github.com/therubymug/hitch}
  s.has_rdoc = false
  s.authors = ["Rogelio Samour", "Les Hill"]
  s.files = %w( README.rdoc Rakefile ) + Dir["{bin,lib}/**/*"].sort
  s.extra_rdoc_files = ["README.rdoc"]
  s.executables = ["hitch", "unhitch", "hitchrc"]
  s.add_dependency('highline', '>= 1.5.0')
end

desc "Generate the static gemspec required for github"
task :gemspec do
  open("hitch.gemspec", "w").write(spec.to_ruby)
end

