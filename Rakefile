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

# EOF
