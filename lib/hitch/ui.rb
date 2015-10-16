HighLine.track_eof = false

module Hitch
  class UI

    def self.prompt_for_group_email
      Hitch.group_email = highline.ask("What is the group email? e.g. dev@hashrocket.com will become dev+therubymug+leshill@hashrocket.com") do |q|
        q.case = :down
        q.validate = /\A[a-zA-Z0-9_\.\-\+]+@[a-zA-Z1-9\-]+\.[a-zA-Z0-9\-\.]+\z/
      end.to_s
    end

    def self.prompt_for_pair(new_author)
      highline.say("I don't know who #{new_author} is.")
      if highline.agree("Do you want to add #{new_author} to ~/.hitch_pairs?")
        author_name = highline.ask("What is #{new_author}'s full name?").to_s
        Hitch::Author.add(new_author, author_name)
        Hitch::Author.write_file
        return new_author
      else
        highline.say("Ignoring #{new_author}.")
      end
      return nil
    end

    private

    def self.highline
      @highline ||= HighLine.new
    end

  end
end
