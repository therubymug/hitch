require 'highline'
require 'yaml'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib git-pair ui]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib git-pair participant]))

module GitPair

  VERSION = '1.0.0'

  def self.print_info
    if GitPair.pairing? && STDOUT.tty?
      GitPair::UI.highline.say("Author: #{GitPair.git_author_name} <#{GitPair.git_author_email}>, Comitter: #{GitPair.git_committer_name} <#{GitPair.git_committer_email}>")
    end
  end

  def self.export(pairs)
    GitPair.current_pair = pairs

    if GitPair.mac?
      `launchctl setenv GIT_AUTHOR_NAME '#{GitPair.git_author_name}' GIT_AUTHOR_EMAIL '#{GitPair.git_author_email}'`
      `launchctl setenv GIT_COMMITTER_NAME '#{GitPair.git_committer_name}' GIT_COMMITTER_EMAIL '#{GitPair.git_committer_email}'`
    end

    write_export_file
    print_info
  end

  def self.expire_command(time)
    %Q(sleep #{to_seconds(time)} && #{GitPair.bin_path} --unpair&)
  end

  def self.unpair
    GitPair.current_pair = []

    if GitPair.mac?
      `launchctl unsetenv GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL`
      `launchctl unsetenv GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL`
    end

    write_export_file
  end

  def self.author_command
    if GitPair.pairing?
      "export GIT_AUTHOR_NAME='#{GitPair.git_author_name}' GIT_AUTHOR_EMAIL='#{GitPair.git_author_email}' GIT_COMMITTER_NAME='#{GitPair.git_committer_name}' GIT_COMMITTER_EMAIL='#{GitPair.git_committer_email}'"
    else
      "unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL"
    end
  end

  def self.current_pair
    config[:current_pair] ||= []
  end

  def self.switch
    if not current_pair.empty?
      GitPair.export current_pair.reverse
    end
  end

  def self.current_pair=(pairs)
    config[:current_pair] = []
    pairs.each do |participant|
      if GitPair::Participant.find(participant)
        config[:current_pair] << participant
      else
        if GitPair::UI.prompt_for_pair(participant)
          config[:current_pair] << participant
        end
      end
    end
    write_file
  end

  def self.git_author_name
    dev = GitPair::Participant.find(current_pair[0])
    dev["name"]
  end

  def self.git_author_email
    dev = GitPair::Participant.find(current_pair[0])
    dev["email"]
  end

  def self.git_committer_name
    dev = GitPair::Participant.find(current_pair[1])
    dev["name"]
  end

  def self.git_committer_email
    dev = GitPair::Participant.find(current_pair[1])
    dev["email"]
  end

  def self.setup_path
    File.join(File.dirname(__FILE__), 'git-pair', 'git-pair.sh')
  end

  def self.print_setup_path
    puts setup_path
  end

  def self.setup
    GitPair::UI.highline.say(File.read(setup_path))
  end

  def self.write_file
    File.open(gitpairrc, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
      YAML.dump(config, out)
    end
  end

  private

  def self.mac?
    (/darwin14/ =~ RUBY_PLATFORM)
  end

  def self.config
    @config ||= get_config
  end

  def self.get_config
    if File.exists?(gitpairrc)
      yamlized = YAML::load_file(gitpairrc)
      return yamlized if yamlized.kind_of?(Hash)
    end
    return {}
  end

  def self.gitpairrc
    File.expand_path('~/.git-pairrc')
  end

  def self.gitpair_export_authors
    File.expand_path('~/.git-pair_export_authors')
  end

  def self.bin_path
    %x[which git-pair].chomp
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
    File.open(gitpair_export_authors, 'w'){|f| f.write(author_command) }
  end

end
