require 'spec_helper'

describe Hitch do

  let(:hitch_pairs) {{'leela' => 'Turanga Leela', 'fry' => 'Philip J. Fry', 'zoidberg' => 'John A. Zoidberg'}}

  let(:hitch_config) do
    { :group_email => 'dev@hashrocket.com',
      :current_pair => ['leela', 'fry'] }
  end

  before do
    Hitch.stub(:config).and_return(hitch_config)
    Hitch::Author.stub(:available_pairs).and_return(hitch_pairs)
  end

  describe '.expire_command' do
    before do
      Hitch.stub(:bin_path).and_return('/usr/local/bin/hitch')
    end

    context 'with a valid string' do
      let(:time_string) { '8' }
      it 'returns the system command to call' do
        Hitch.expire_command(time_string).should == 'sleep 28800 && /usr/local/bin/hitch --unhitch&'
      end
    end

    context 'with a valid integer' do
      let(:time_string) { 8 }
      it 'returns the system command to call' do
        Hitch.expire_command(time_string).should == 'sleep 28800 && /usr/local/bin/hitch --unhitch&'
      end
    end

    context 'with an invalid string' do
      let(:time_string) { 'BAR' }
      it 'raises an error' do
        expect {Hitch.expire_command(time_string)}.to raise_error(StandardError)
      end
    end

  end

  describe '.author_command' do

    context 'when pairing' do
      it 'returns the export shell command for GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL' do
        Hitch.current_pair = ['leela', 'fry']
        Hitch.author_command.should == "export GIT_AUTHOR_NAME='Philip J. Fry and Turanga Leela' GIT_AUTHOR_EMAIL='dev+fry+leela@hashrocket.com'"
      end
    end

    context 'when not pairing' do
      it 'returns the unset shell command for GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL' do
        Hitch.current_pair = []
        Hitch.author_command.should == "unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL"
      end
    end

    context 'with more than 2 developers' do
      it "joins 3+ developers together with commas and an 'and'" do
        Hitch.current_pair = ['leela', 'fry', 'zoidberg']
        Hitch.author_command.should == "export GIT_AUTHOR_NAME='Philip J. Fry, Turanga Leela, and John A. Zoidberg' GIT_AUTHOR_EMAIL='dev+fry+leela+zoidberg@hashrocket.com'"
      end
    end

  end

  describe '.unhitch' do

    let(:pairs) { ['fry', 'leela'] }

    it 'sets the current pair to an empty array' do
      Hitch.should_receive(:current_pair=).with([])
      Hitch.unhitch
    end

    it 'writes the export file' do
      Hitch.should_receive(:write_export_file)
      Hitch.unhitch
    end

  end

  describe '.print_info' do

    context 'when pairing' do
      it 'returns the pair name and email being used' do
        Hitch::UI.highline.should_receive(:say).with("Philip J. Fry and Turanga Leela <dev+fry+leela@hashrocket.com>")
        Hitch.current_pair = ['leela', 'fry']
        Hitch.print_info
      end
    end

    context 'when not pairing' do
      it 'returns nothing' do
        Hitch.current_pair = []
        Hitch.print_info.should be_nil
      end
    end

    context 'when not in an interactive shell' do
      it 'returns nothing' do
        STDOUT.stub(:tty?).and_return(false)
        Hitch::UI.highline.should_not_receive(:say)
        Hitch.current_pair = ['leela', 'fry']
        Hitch.print_info
      end
    end

  end

  describe '.export' do

    let(:pairs) { ['fry', 'leela'] }

    before do
      Hitch.stub(:print_info)
    end

    it 'sets the current pair' do
      Hitch.should_receive(:current_pair=).with(pairs)
      Hitch.export(pairs)
    end

    it 'writes the export file' do
      Hitch.should_receive(:write_export_file)
      Hitch.export(pairs)
    end

    it 'prints out pair info' do
      Hitch.should_receive(:print_info)
      Hitch.export(pairs)
    end

  end

  describe '.current_pair=' do

    before { Hitch.stub(:write_file) }

    it 'writes the hitchrc file' do
      Hitch.should_receive(:write_file)
      Hitch.current_pair = ['leela', 'fry']
    end

    context 'when there are no new authors' do
      it 'sets the current pair with the authors given' do
        Hitch.current_pair = ['leela', 'fry']
        Hitch.current_pair.should == ['leela', 'fry']
      end
    end

    context 'when there are new authors' do

      let(:new_author) { 'therubymug' }

      it "prompts for the new author's info" do
        Hitch::UI.should_receive(:prompt_for_pair).with(new_author)
        Hitch.current_pair = [new_author, 'fry']
      end

      it 'adds the new author to current pair' do
        Hitch::UI.stub(:prompt_for_pair).and_return(new_author)
        Hitch.current_pair = [new_author, 'fry']
        Hitch.current_pair.should == [new_author, 'fry']
      end

    end

  end

  describe '.current_pair' do
    it 'returns an array of Github usernames' do
      Hitch.stub(:config).and_return(hitch_config)
      Hitch.current_pair.should == ['leela', 'fry']
    end
  end

  describe '.group_email' do

    context 'when absent from Hitch.config' do
      before { Hitch.stub(:config).and_return({}) }
      it 'prompts the user for it' do
        Hitch::UI.should_receive(:prompt_for_group_email)
        Hitch.group_email
      end
    end

    context 'when present in Hitch.config' do
      it 'returns the value' do
        Hitch.group_email.should == 'dev@hashrocket.com'
      end
    end

  end

  describe '.group_email=' do

    before { Hitch.stub(:write_file) }

    it 'writes the hitchrc file' do
      Hitch.should_receive(:write_file)
      Hitch.group_email = 'dev@hashrocket.com'
    end

    it 'sets the current pair with the authors given' do
      Hitch.group_email = 'dev@hashrocket.com'
      Hitch.group_email.should == 'dev@hashrocket.com'
    end

  end

  describe '.group_prefix' do
    it 'returns the user portion of the group email' do
      Hitch.group_prefix.should == 'dev'
    end
  end

  describe '.group_domain' do
    it 'returns the user portion of the group email' do
      Hitch.group_domain.should == 'hashrocket.com'
    end
  end

  describe '.git_author_name' do
    it 'returns all author names joined by an "and" sorted alphabetically' do
      Hitch.git_author_name.should == 'Philip J. Fry and Turanga Leela'
    end
  end

  describe '.git_author_email' do
    it 'returns all author github names coalesced into the group email' do
      Hitch.git_author_email.should == 'dev+fry+leela@hashrocket.com'
    end
  end

  describe ".write_file" do
    it "writes the contents of Hitch.config to the hitchrc file" do
      YAML.should_receive(:dump)
      Hitch.write_file
    end
  end

end
