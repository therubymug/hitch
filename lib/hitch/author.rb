module Hitch
  class Author

    def self.add(author_github, author_email)
      unless find(author_github)
        available_pairs[author_github] = author_email
      end
    end

    def self.find(author_github)
      available_pairs[author_github]
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
