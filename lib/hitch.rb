require 'highline'

module Hitch
  # :stopdoc:
  VERSION = '0.0.1'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

  HighLine.track_eof = false

  def write_hitchrc
    personal_info['pairing_with'] = pairing_with
    File.open(hitchrc, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
      YAML.dump(personal_info, out)
    end
  end

  def hitchrc
    @hitchrc ||= File.expand_path("~/.hitchrc")
  end

  def personal_info
    if File.exists?(hitchrc)
      @personal_info ||= YAML::load_file(hitchrc)
    else
      @personal_info ||= {}
    end
  end

  def hitch_pairs
    @hitch_pairs ||= File.expand_path("~/.hitch_pairs")
  end

  def pairs
    if File.exists?(hitch_pairs)
      @pairs ||= YAML::load_file(hitch_pairs)
    else
      @pairs ||= {}
    end
  end

  def write_hitch_pairs
    File.open(hitch_pairs, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
      YAML.dump(pairs, out)
    end
  end

  def ui
    @ui ||= HighLine.new
  end

  def valid_hitchrc?(hitchrc)
    return false if hitchrc.empty?
    return false if hitchrc['my_name'].empty?
    return false if hitchrc['my_github'].empty?
    return false if hitchrc['group_email'].empty?
    return true
  end

  def write_gitconfig
    clean_gitconfig
    File.open(File.join(ENV['HOME'], ".gitconfig"), "a+") do |f|
      f.puts "# start - lines added by hitch #"
      f.puts "[user]"
      f.puts "\tname = '#{hitch_name}'"
      f.puts "\temail = #{hitch_email}"
      f.puts "# end - lines added by hitch #"
    end
  end

  def add_pair(git_name)
    pairing_with << git_name
    pairing_with.sort!
    pairing_with.uniq!
  end

  def pairing_with
    @pairing_with ||= (personal_info['pairing_with'] or [])
  end

  def hitch_name
    my_pairs_and_i.map {|github, name| name}.join(' and ')
  end

  def hitch_email
    "#{group_prefix}+#{my_pairs_and_i.map{|github, name| github}.join('+')}@#{group_domain}"
  end

  def my_pairs_and_i
    and_i = pairing_with.map {|github| [github, pairs[github]]}
    and_i << [personal_info['my_github'], personal_info['my_name']]
    and_i.sort_by {|github, name| github }
  end

  def group_prefix
    personal_info['group_email'].split('@').first
  end

  def group_domain
    personal_info['group_email'].split('@').last
  end

  def clean_gitconfig
    config_file = File.expand_path("~/.gitconfig")
    body = File.read(config_file)
    body.gsub!(/# start - lines added by hitch #\n.*?\n# end - lines added by hitch #\n/m, '')
    File.open(config_file + ".tmp", 'w') {|f| f.write(body)}
    File.rename(config_file + ".tmp", config_file)
  end

  def prep_gitconfig
    if pairing?
      write_gitconfig
    else
      clean_gitconfig
    end
  end

  def unhitch
    if personal_info
      clear_pair_info
      write_hitchrc
      clean_gitconfig
      print_current_status
    end
  end

  def print_current_status
    if pairing?
      ui.say " Currently pairing with #{pairing_with.join(' ')}."
    else
      ui.say " Currently coding solo."
    end
  end

  def print_version
    ui.say "hitch v#{Hitch.version}"
  end

  def print_help
    print_version
    ui.say ""
    ui.say "Usage:"
    ui.say "\thitch <github_username>"
    ui.say "\thitch -i to see all available pairs"
    ui.say "\tunhitch to clear"
    ui.say "\thitchrc to create ~/.hitchrc"
    ui.say ""
  end

  def clear_pair_info
    personal_info['pairing_with'] = []
  end

  def pairing?
    return false if personal_info.empty?
    return false if personal_info['pairing_with'].nil? || personal_info['pairing_with'].length.zero?
    true
  end

  def existing_pair?(pair)
    pairs.any? {|github, name| github == pair}
  end

  def interactive
    key = pair_name = ""
    ui.choose do |menu|
      menu.prompt = "Who is your pair?"
      pairs.sort_by {|github, name| github }.each do |github, name|
        menu_label = github == personal_info['my_github'] ? "#{github}: #{personal_info['my_name']} (Pick yourself to code solo)" : "#{github}: #{name}"
        menu.choice(menu_label) do
          clear_pair_info
          unless github == personal_info['my_github']
            add_pair(github)
          end
        end
      end
    end
    write_hitchrc
    prep_gitconfig
  end

  def hitch
    opts = ARGV
    case opts
    when ["-i"]
      interactive
    when ["-h"]
      print_help
    when ["-v"]
      print_version
    else
      if opts.any?
        save_pairs = false
        clear_pair_info

        opts.each do |opt|
          unless existing_pair?(opt)
            ui.say("I don't know who #{opt} is.")
            if ui.agree("Do you want to add #{opt} to ~/.hitch_pairs?  ", true)
              pairs[opt] = ui.ask("What is #{opt}'s full name?") do |q|
                q.validate = /\A[(\w+)\s?]+\Z/
              end
              add_pair(opt)
              save_pairs ||= true
            else
              ui.say("Ignoring #{opt}.")
            end
          else
            add_pair(opt)
          end
        end
        write_hitchrc
        write_hitch_pairs if save_pairs
        prep_gitconfig
      end

      print_current_status
    end
  end

  def create_hitchrc
    begin
      unless File.exists?(hitchrc) and !ui.agree("Do you want to overwrite your #{ENV['HOME']}/.hitchrc file?", true)
        ui.say("We need to setup your #{ENV['HOME']}/.hitchrc file")
        personal_info['my_name'] = ui.ask("What is your full name?") do |q|
          q.validate = /\A([\w\.\(\)]+\s?)+\z/
        end

        personal_info['my_github'] = ui.ask("What is your github username?") do |q|
          q.case     = :down
          q.validate = /\A[a-z0-9\-]+\z/
        end

        personal_info['group_email'] = ui.ask("What is the group email? e.g. dev@hashrocket.com will become dev+therubymug+leshill@hashrocket.com") do |q|
          q.case     = :down
          q.validate = /\A[a-zA-Z0-9_\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+\z/ # Simple email validation.
        end

        write_hitchrc
      end
    rescue EOFError  # HighLine throws this if @input.eof?
      break
    end

    print_current_status
  end
end  # module Hitch

Hitch.require_all_libs_relative_to(__FILE__)

# EOF
