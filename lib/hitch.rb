require 'highline'
require 'yaml'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib hitch author]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib hitch ui]))

module Hitch

  VERSION = '1.0.1'

  def self.print_info
    if Hitch.pairing? && STDOUT.tty?
      Hitch::UI.highline.say("#{Hitch.git_author_name} <#{Hitch.git_author_email}>")
    end
  end

  def self.export(pairs)
    Hitch.current_pair = pairs
    write_export_file
    print_info
  end

  def self.expire_command(time)
    %Q(sleep #{to_seconds(time)} && #{Hitch.bin_path} --unhitch&)
  end

  def self.unhitch
    Hitch.current_pair = []
    write_export_file
  end

  def self.author_command
    if Hitch.pairing?
      "export GIT_AUTHOR_NAME='#{Hitch.git_author_name}' GIT_AUTHOR_EMAIL='#{Hitch.git_author_email}'"
    else
      "unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL"
    end
  end

  def self.group_email
    config[:group_email] ||= Hitch::UI.prompt_for_group_email
  end

  def self.group_email=(email)
    config[:group_email] = email
    write_file
  end

  def self.current_pair
    config[:current_pair] ||= []
  end

  def self.current_pair=(pairs)
    config[:current_pair] = []
    pairs.each do |author|
      if Hitch::Author.find(author)
        config[:current_pair] << author
      else
        if Hitch::UI.prompt_for_pair(author)
          config[:current_pair] << author
        end
      end
    end
    write_file
  end

  def self.git_author_name
    devs = current_pair.sort.map {|pair| Hitch::Author.find(pair)}
    case devs.length
    when 1, 2
      devs.join(" and ")
    else
      "#{devs[0...-1].join(', ')}, and #{devs[-1]}"
    end
  end

  def self.git_author_email
    "#{group_prefix}+#{current_pair.sort.join('+')}@#{group_domain}"
  end

  def self.group_prefix
    group_email.split('@').first
  end

  def self.group_domain
    group_email.split('@').last
  end

  def self.setup_path
    File.join(File.dirname(__FILE__), 'hitch', 'hitch.sh')
  end

  def self.print_setup_path
    puts setup_path
  end

  def self.setup
    Hitch::UI.highline.say(File.read(setup_path))
  end

  def self.write_file
    File.open(hitchrc, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
      YAML.dump(config, out)
    end
  end

  private

  def self.config
    @config ||= get_config
  end

  def self.get_config
    if File.exists?(hitchrc)
      yamlized = YAML::load_file(hitchrc)
      return yamlized if yamlized.kind_of?(Hash)
    end
    return {}
  end

  def self.hitchrc
    File.expand_path('~/.hitchrc')
  end

  def self.hitch_export_authors
    File.expand_path('~/.hitch_export_authors')
  end

  def self.bin_path
    %x[which hitch].chomp
  end

  def self.pairing?
    current_pair.any?
  end

  def self.to_seconds(value)
    value = value.to_s.gsub(/[^\d]/, '').to_i
    unless value.zero?
      value * 60 * 60
    else
      raise StandardError
    end
  end

  def self.write_export_file
    File.open(hitch_export_authors, 'w'){|f| f.write(author_command) }
  end

end
