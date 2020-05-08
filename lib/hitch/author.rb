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
      File.open(hitch_pairs_current_file, File::CREAT|File::TRUNC|File::RDWR, 0644) do |out|
        YAML.dump(available_pairs, out)
      end
    end

    private

    def self.hitch_pairs_current_file
      hitch_pairs.find { |file| File.exists?(file) }
    end

    def self.hitch_pairs
      %w(./.hitch_pairs ~/.hitch_pairs).map { |file|
        File.expand_path(file)
      }
    end

    def self.available_pairs
      @available_pairs ||= get_available_pairs
    end

    def self.get_available_pairs
      hitch_pairs.reduce({}) { |pairs, pair_file|
        if File.exists?(pair_file)
          yamlized = YAML::load_file(pair_file)
          yamlized.merge!(pairs) if yamlized.kind_of?(Hash)
        end
        pairs
      }
    end

  end
end
