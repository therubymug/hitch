require 'highline'
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib hitch options]))

module Hitch

  # :stopdoc:
  VERSION = '0.5.1'
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
    personal_info['current_pair'] = current_pair
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

  def exporting_hitch_authors
    !!hitch_options.export_hitch_authors
  end

  def write_hitch_authors
    File.open(File.expand_path('~/.hitch_export_authors'), "w") do |f|
      f.puts "# "
      f.puts "export GIT_AUTHOR_NAME='#{hitch_name}'"
      f.puts "export GIT_AUTHOR_EMAIL='#{hitch_email}'"
    end
  end

  def write_gitconfig
    clean_gitconfig
    File.open(hitch_options.current_gitconfig, "a+") do |f|
      f.puts "# start - lines added by hitch #"
      f.puts "[user]"
      f.puts "\tname = '#{hitch_name}'"
      f.puts "\temail = #{hitch_email}"
      f.puts "# end - lines added by hitch #"
    end
  end

  def add_pair(git_name)
    current_pair << git_name
    current_pair.sort!
    current_pair.uniq!
  end

  def current_pair
    @current_pair ||= (personal_info['current_pair'] or [])
  end

  def hitch_name
    my_pairs_and_i.map {|github, name| name}.join(' and ')
  end

  def hitch_email
    "#{group_prefix}+#{my_pairs_and_i.map{|github, name| github}.join('+')}@#{group_domain}"
  end

  def my_pairs_and_i
    and_i = current_pair.map {|github| [github, pairs[github]]}
    and_i.sort_by {|github, name| github }
  end

  def group_prefix
    personal_info['group_email'].split('@').first
  end

  def group_domain
    personal_info['group_email'].split('@').last
  end

  def clean_hitch_authors
    authors_file = File.expand_path '~/.hitch_export_authors'
    File.open(authors_file, 'w') do |f|
      f.puts "unset GIT_AUTHOR_NAME"
      f.puts "unset GIT_AUTHOR_EMAIL"
    end
  end

  def clean_gitconfig(opts={:print => false})
    config_file = hitch_options.current_gitconfig
    ui.say " Clearing hitch info in: #{config_file}" if opts[:print]
    body = File.read(config_file)
    body.gsub!(/# start - lines added by hitch #\n.*?\n# end - lines added by hitch #\n/m, '')
    File.open(config_file + ".tmp", 'w') {|f| f.write(body)}
    File.rename(config_file + ".tmp", config_file)
  end

  def prep_hitch_authors
    if pairing?
      write_hitch_authors
    else
      clean_hitch_authors
    end
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
      if exporting_hitch_authors
        clean_hitch_authors
      else
        clean_gitconfig(:print => true)
      end
      print_current_status
    end
  end

  def print_current_status
    if pairing?
      ui.say " Currently pairing with #{current_pair.join(' ')}."
    else
      ui.say " Currently coding solo."
    end
  end

  def print_version
    ui.say "hitch v#{Hitch.version}"
  end

  def clear_pair_info
    personal_info['current_pair'] = []
  end

  def pairing?
    return false if personal_info.empty?
    return false if personal_info['current_pair'].nil? || personal_info['current_pair'].length.zero?
    return false if personal_info['current_pair'].length < 2
    true
  end

  def existing_pair?(pair)
    pairs.any? {|github, name| github == pair}
  end

  def hitch_options
    @hitch_options ||= Options.parse(ARGV)
  end

  def hitch
    case hitch_options.action
    when "manage_hitchrc"
      manage_hitchrc
    when "unhitch"
      unhitch
    when "hitch"
      if ARGV.any? && ARGV.size >= 2
        potential_pairs = ARGV
        save_pairs = false
        clear_pair_info

        potential_pairs.each do |pair|
          unless existing_pair?(pair)
            ui.say("I don't know who #{pair} is.")
            if ui.agree("Do you want to add #{pair} to ~/.hitch_pairs?  ", true)
              pairs[pair] = ui.ask("What is #{pair}'s full name?") do |q|
                q.validate = /\A[-(\w|.,)+\s?]+\Z/
              end
              add_pair(pair)
              save_pairs ||= true
            else
              ui.say("Ignoring #{pair}.")
            end
          else
            add_pair(pair)
          end
        end
        write_hitchrc
        write_hitch_pairs if save_pairs
        if exporting_hitch_authors
          prep_hitch_authors
        else
          prep_gitconfig
        end
      else
        ui.say " Silly Rabbit! A pair is comprised of two." unless ARGV.size.zero?
      end
      print_current_status
    end
  end

  def manage_hitchrc
    begin
      unless File.exists?(hitchrc) and !ui.agree("Do you want to overwrite your #{ENV['HOME']}/.hitchrc file?", true)
        ui.say("Let's setup your #{ENV['HOME']}/.hitchrc file")

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
