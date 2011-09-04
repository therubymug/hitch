require 'spec_helper'

describe Hitch::UI do

  describe '.prompt_for_group_email' do

    it 'prompts for group email' do
      Hitch::UI.highline.should_receive(:ask).with("What is the group email? e.g. dev@hashrocket.com will become dev+therubymug+leshill@hashrocket.com")
      Hitch::UI.prompt_for_group_email
    end

    it 'returns the given group email' do
      Hitch::UI.highline.stub(:ask).with("What is the group email? e.g. dev@hashrocket.com will become dev+therubymug+leshill@hashrocket.com").and_return('dev@hashrocket.com')
      Hitch::UI.prompt_for_group_email.should == 'dev@hashrocket.com'
    end

    it 'sets Hitch.group_email' do
      Hitch.should_receive('group_email=').with('dev@hashrocket.com')
      Hitch::UI.highline.stub(:ask).with("What is the group email? e.g. dev@hashrocket.com will become dev+therubymug+leshill@hashrocket.com").and_return('dev@hashrocket.com')
      Hitch::UI.prompt_for_group_email
    end

  end

  describe '.prompt_for_pair' do

    let(:new_author) { 'leela' }
    let(:new_author_name) { 'Turanga Leela' }

    before do
      Hitch::UI.highline.stub(:ask).and_return(new_author_name)
      Hitch::UI.highline.stub(:say)
    end

    it 'states that the new pair is not in the hitch_pairs file' do
      Hitch::UI.highline.should_receive(:say).with("I don't know who #{new_author} is.")
      Hitch::UI.prompt_for_pair(new_author)
    end

    it 'prompts for pair' do
      Hitch::UI.highline.should_receive(:agree).with("Do you want to add #{new_author} to ~/.hitch_pairs?", true)
      Hitch::UI.prompt_for_pair(new_author)
    end

    context 'when user does not agree to add new author' do
      it "states it's ignoring the author" do
        Hitch::UI.highline.stub(:agree).and_return(false)
        Hitch::UI.highline.should_receive(:say).with("Ignoring #{new_author}.")
        Hitch::UI.prompt_for_pair(new_author)
      end
    end

    context 'when user agrees to add new author' do

      before do
        Hitch::UI.highline.stub(:agree).and_return(true)
      end

      it "asks for the new author's name" do
        Hitch::UI.highline.should_receive(:ask).with("What is #{new_author}'s full name?")
        Hitch::UI.prompt_for_pair(new_author)
      end

      it "adds the new author" do
        Hitch::Author.should_receive(:add).with(new_author, new_author_name)
        Hitch::UI.prompt_for_pair(new_author)
      end

      it "writes the ~/.hitch_pairs file" do
        Hitch::Author.should_receive(:write_file)
        Hitch::UI.prompt_for_pair(new_author)
      end

    end

  end

end
