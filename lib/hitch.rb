require 'highline'
require 'yaml'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib hitch author]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib hitch ui]))

module Hitch

  def self.group_email
    config[:group_email] ||= Hitch::UI.prompt_for_group_email
  end

  def self.group_email=(email)
    config[:group_email] = email
    Hitch.write_file
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
        if new_author = Hitch::UI.prompt_for_pair(author)
          config[:current_pair] << author
        end
      end
    end
    Hitch.write_file
  end

  def self.git_author_name
    current_pair.sort.map {|pair| Hitch::Author.find(pair)}.join(' and ')
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

  def self.write_file
    File.open(hitchrc, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
      YAML.dump(config, out)
    end
  end

  private

  def self.hitchrc
    File.expand_path('~/.hitchrc')
  end

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

end
