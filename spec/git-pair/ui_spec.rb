require 'spec_helper'

describe GitPair::UI do

  describe '.prompt_for_pair' do

    let(:new_author) { 'leela' }
    let(:new_author_name) { 'Turanga Leela' }
    let(:new_author_email) { 'Turanga Leela' }


    before do
      allow(GitPair::UI.highline).to receive(:ask) {new_author_name}
      # expect(GitPair::UI.highline).to receive(:say)
    end

    it 'states that the new pair is not in the git-pair_pairs file' do
      expect(GitPair::UI.highline).to receive(:say).with("I don't know who #{new_author} is.")
      GitPair::UI.prompt_for_pair(new_author)
    end

    it 'prompts for pair' do
      expect(GitPair::UI.highline).to receive(:say)
      expect(GitPair::UI.highline).to receive(:agree).with("Do you want to add #{new_author} to ~/.git-pair_pairs? (yn)")
      expect(GitPair::UI.highline).to receive(:say)
      GitPair::UI.prompt_for_pair(new_author)
    end

    context 'when user does not agree to add new author' do
      it "states it's ignoring the author" do
        allow(GitPair::UI.highline).to receive(:agree) {false}
        expect(GitPair::UI.highline).to receive(:say)
        expect(GitPair::UI.highline).to receive(:say).with("Ignoring #{new_author}.")
        GitPair::UI.prompt_for_pair(new_author)
      end
    end

    context 'when user agrees to add new author' do

      before do
        allow(GitPair::UI.highline).to receive(:agree) {true}
        expect(GitPair::UI.highline).to receive(:say)
      end

      it "asks for the new author's name" do
        expect(GitPair::UI.highline).to receive(:ask).with("What is #{new_author}'s full name?")
        GitPair::UI.prompt_for_pair(new_author)
      end

      it "adds the new author" do
        expect(GitPair::Participant).to receive(:add).with(new_author, new_author_name, new_author_email)
        GitPair::UI.prompt_for_pair(new_author)
      end

      it "writes the ~/.hitch_pairs file" do
        expect(GitPair::Participant).to receive(:write_file)
        GitPair::UI.prompt_for_pair(new_author)
      end

    end

  end

end
