require 'optparse'
require 'optparse/time'
require 'ostruct'

module Hitch

  class Options

    def self.parse(args)
      options = OpenStruct.new
      options.action = "hitch"

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: hitch [options] first_pair_username second_pair_username"
        opts.separator ""
        opts.separator "Hitch defaults to the current project's .git/config"
        opts.separator ""
        opts.separator "General options:"

        opts.on('-p', '--preserve_gitconfig', 'Preserves your ~/.gitconfig and .git/config files.  Uses ~/.hitch_export_authors instead') do
          options.export_hitch_authors = true
        end

        opts.on("-g", "--global", "Modifies your global ~/.gitconfig") do
          options.current_gitconfig = File.expand_path("~/.gitconfig")
        end

        opts.on("-m", "--manage-hitchrc", "Creates or manages your personal information into ~/.hitchrc") do
          if options.action.empty? || options.action == "hitch"
            options.action = "manage_hitchrc"
          else
            abort "You can only perform one action at a time. hitch -h for more info."
          end
        end

        opts.on("-u", "--unhitch", "Clear pair information") do
          if options.action.empty? || options.action == "hitch"
            options.action = "unhitch"
          else
            abort "You can only perform one action at a time. hitch -h for more info."
          end
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show version") do
          abort "hitch v#{Hitch.version}"
        end
      end

      opts.parse!(args)

      if options.current_gitconfig.nil?
        options.current_gitconfig = File.expand_path(File.join(Dir.pwd, ".git", "config"))
      end

      unless File.exists?(options.current_gitconfig)
        abort "Config File: #{options.current_gitconfig} does not exist. hitch -h for more info."
      end

      options
    end

  end
end
