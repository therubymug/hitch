require 'spec_helper'

describe GitPair do

  let(:pairs_data) {
    {
      'leela'    => { 'name' => 'Turanga Leela',    'email' => 'leela@futurama.test'}, 
      'fry'      => { 'name' => 'Philip J. Fry',    'email' => 'fry@futurama.test'}, 
      'zoidberg' => { 'name' => 'John A. Zoidberg', 'email' => 'zoidberg@futurama.test' }
    }
  }

  let(:gitpair_config) do
    {
      :current_pair => ["leela", "fry"]
    }
  end

  before do
    allow(GitPair::Participant).to receive(:config) { gitpair_config }
    allow(GitPair::Participant).to receive(:available_pairs) { pairs_data }
    allow(GitPair).to receive(:write_file)
  end

  describe '.print_info' do

    context 'when pairing' do
      it 'returns the author and commiters names and emails' do
        expect(GitPair::UI.highline).to receive(:say).with("Author: Turanga Leela <leela@futurama.test>, Comitter: Philip J. Fry <fry@futurama.test>")
        GitPair.current_pair = ['leela', 'fry']
        GitPair.print_info
      end
    end

    context 'when not pairing' do
      it 'returns nothing' do
        GitPair.current_pair = []
        expect(GitPair.print_info).to be_nil
      end
    end

    context 'when not in an interactive shell' do
      it 'returns nothing' do
        allow(STDOUT).to receive(:tty?) { false }
        expect(GitPair::UI.highline).to_not receive(:say)
        GitPair.current_pair = ['leela', 'fry']
        GitPair.print_info
      end
    end

  end

  describe '.switch' do

    it "switches the author and commiter around" do
      allow(GitPair::UI.highline).to receive(:say)
      GitPair.current_pair= ['leela', 'fry']
      expect(GitPair.current_pair).to eql(['leela', 'fry'])
      GitPair.switch
      expect(GitPair.current_pair).to eql(["fry", "leela"])
    end
  end

  describe '.export' do

    let(:pairs) { ['fry', 'leela'] }

    before do
      allow(GitPair).to receive(:print_info)
    end

    it 'sets the current pair' do
      expect(GitPair).to receive(:current_pair=) {pairs}
      GitPair.export(pairs)
    end

    it 'writes the export file' do
      expect(GitPair).to receive(:write_export_file)
      GitPair.export(pairs)
    end

    it 'prints out pair info' do
      expect(GitPair).to receive(:print_info)
      GitPair.export(pairs)
    end

  end

  describe '.expire_command' do
    before do
      allow(GitPair).to receive(:bin_path) {'/usr/local/bin/git-pair'}
    end

    context 'with a valid string' do
      let(:time_string) { '8' }
      it 'returns the system command to call' do
        expect(GitPair.expire_command(time_string)).to eql('sleep 28800 && /usr/local/bin/git-pair --unpair&')
      end
    end

    context 'with a valid integer' do
      let(:time_string) { 8 }
      it 'returns the system command to call' do
        expect(GitPair.expire_command(time_string)).to  eql('sleep 28800 && /usr/local/bin/git-pair --unpair&')
      end
    end

    context 'with an invalid string' do
      let(:time_string) { 'BAR' }
      it 'raises an error' do
        expect {GitPair.expire_command(time_string)}.to raise_error(StandardError)
      end
    end

  end

  describe '.unpair' do

    let(:pairs) { ['fry', 'leela'] }

    it 'sets the current pair to an empty array' do
      allow(GitPair).to receive(:current_pair=)
      GitPair.unpair
    end

    it 'writes the export file' do
      allow(GitPair).to receive(:write_export_file)
      GitPair.unpair
    end

  end

  describe '.author_command' do

    context 'when pairing' do
      it 'returns the export shell command for GIT_AUTHOR_* and GIT_COMMITTER_*' do
        GitPair.current_pair = ['leela', 'fry']
        expect(GitPair.author_command).to eql("export GIT_AUTHOR_NAME='Turanga Leela' GIT_AUTHOR_EMAIL='leela@futurama.test' GIT_COMMITTER_NAME='Philip J. Fry' GIT_COMMITTER_EMAIL='fry@futurama.test'")
      end

      it 'uses the first pair as author and the second as commiter' do
        GitPair.current_pair = ['fry', 'leela']
        expect(GitPair.author_command).to eql("export GIT_AUTHOR_NAME='Philip J. Fry' GIT_AUTHOR_EMAIL='fry@futurama.test' GIT_COMMITTER_NAME='Turanga Leela' GIT_COMMITTER_EMAIL='leela@futurama.test'")
      end
    end

    context 'when not pairing' do
      it 'returns the unset shell command for GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL' do
        GitPair.current_pair = []
        expect(GitPair.author_command).to eql("unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL")
      end
    end

    context 'with more than 2 developers' do
      it "ignores the everyone but the first two" do
        GitPair.current_pair = ['leela', 'fry', 'zoidberg']
        expect(GitPair.author_command).to eql("export GIT_AUTHOR_NAME='Turanga Leela' GIT_AUTHOR_EMAIL='leela@futurama.test' GIT_COMMITTER_NAME='Philip J. Fry' GIT_COMMITTER_EMAIL='fry@futurama.test'")
      end
    end

  end

  describe '.current_pair' do
    it 'returns an array of Github usernames' do
      allow(GitPair).to receive(:config) {gitpair_config}
      expect(GitPair.current_pair).to eql(['leela', 'fry'])
    end
  end

  describe '.current_pair=' do

    before { allow(GitPair).to receive(:write_file) }

    it 'writes the git-pairrc file' do
      expect(GitPair).to receive(:write_file)
      GitPair.current_pair = ['leela', 'fry']
    end

    context 'when there are no new participants' do
      it 'sets the current pair with the participants given' do
        GitPair.current_pair = ['leela', 'fry']
        expect(GitPair.current_pair).to eql(['leela', 'fry'])
      end
    end

    context 'when there are new participants' do

      let(:new_participant) { 'therubymug' }

      it "prompts for the new participant's info" do
        expect(GitPair::UI).to receive(:prompt_for_pair).with(new_participant)
        GitPair.current_pair = [new_participant, 'fry']
      end

      it 'adds the new participant to current pair' do
        allow(GitPair::UI).to receive(:prompt_for_pair) {new_participant}
        GitPair.current_pair = [new_participant, 'fry']
        expect(GitPair.current_pair).to eql([new_participant, 'fry'])
      end

    end
  end

  describe '.git_author_name' do
    it "returns the first participant's name" do
      allow(GitPair).to receive(:config) { gitpair_config }
      expect(GitPair.git_author_name).to eql('Turanga Leela')
    end
  end

  describe '.git_author_email' do
    it "returns the first participant's email" do
      allow(GitPair).to receive(:config) { gitpair_config }
      expect(GitPair.git_author_email).to eql('leela@futurama.test')
    end
  end

  describe '.git_committer_name' do
    it "returns the second participant's name" do
      allow(GitPair).to receive(:config) { gitpair_config }
      expect(GitPair.git_committer_name).to eql('Philip J. Fry')
    end
  end

  describe '.git_committer_email' do
    it "returns the second participant's email" do
      allow(GitPair).to receive(:config) { gitpair_config }
      expect(GitPair.git_committer_email).to eql('fry@futurama.test')
    end
  end


end
