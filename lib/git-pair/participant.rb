module GitPair
  class Participant

    def self.add(github, email, name)
      unless find(github)
        available_pairs[github] = {}
        available_pairs[github]["email"] = email
        available_pairs[github]["name"] = name
      end
    end

    def self.find(github)
      available_pairs[github]
    end

    def self.write_file
      File.open(hitch_pairs, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
        YAML.dump(available_pairs, out)
      end
    end

    private

    def self.hitch_pairs
      File.expand_path("~/.hitch_pairs")
    end

    def self.available_pairs
      @available_pairs ||= get_available_pairs
    end

    def self.get_available_pairs
      if File.exists?(hitch_pairs)
        yamlized = YAML::load_file(hitch_pairs)
        return yamlized if yamlized.kind_of?(Hash)
      end
      return {}
    end

  end
end
