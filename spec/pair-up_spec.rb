require 'spec_helper'

describe PairUp do

  let(:pairs_data) {
    {
      'leela'    => { 'name' => 'Turanga Leela',    'email' => 'leela@futurama.test'}, 
      'fry'      => { 'name' => 'Philip J. Fry',    'email' => 'fry@futurama.test'}, 
      'zoidberg' => { 'name' => 'John A. Zoidberg', 'email' => 'zoidberg@futurama.test' }
    }
  }

  let(:config) do
    {
      :current_pair => ["leela", "fry"]
    }
  end

  before do
    allow(PairUp::Participant).to receive(:config) { config }
    allow(PairUp::Participant).to receive(:available_pairs) { pairs_data }
    allow(PairUp).to receive(:write_file)
  end

  describe '.print_info' do

    context 'when pairing' do
      it 'returns the author and commiters names and emails' do
        expect(PairUp::UI.highline).to receive(:say).with("Author: Turanga Leela <leela@futurama.test>, Comitter: Philip J. Fry <fry@futurama.test>")
        PairUp.current_pair = ['leela', 'fry']
        PairUp.print_info
      end
    end

    context 'when not pairing' do
      it 'returns nothing' do
        PairUp.current_pair = []
        expect(PairUp.print_info).to be_nil
      end
    end

    context 'when not in an interactive shell' do
      it 'returns nothing' do
        allow(STDOUT).to receive(:tty?) { false }
        expect(PairUp::UI.highline).to_not receive(:say)
        PairUp.current_pair = ['leela', 'fry']
        PairUp.print_info
      end
    end

  end

  describe '.switch' do

    it "switches the author and commiter around" do
      allow(PairUp::UI.highline).to receive(:say)
      PairUp.current_pair= ['leela', 'fry']
      expect(PairUp.current_pair).to eql(['leela', 'fry'])
      PairUp.switch
      expect(PairUp.current_pair).to eql(["fry", "leela"])
    end
  end

  describe '.export' do

    let(:pairs) { ['fry', 'leela'] }

    before do
      allow(PairUp).to receive(:print_info)
    end

    it 'sets the current pair' do
      expect(PairUp).to receive(:current_pair=) {pairs}
      PairUp.export(pairs)
    end

    it 'writes the export file' do
      expect(PairUp).to receive(:write_export_file)
      PairUp.export(pairs)
    end

    it 'prints out pair info' do
      expect(PairUp).to receive(:print_info)
      PairUp.export(pairs)
    end

  end

  describe '.expire_command' do
    before do
      allow(PairUp).to receive(:bin_path) {'/usr/local/bin/pair'}
    end

    context 'with a valid string' do
      let(:time_string) { '8' }
      it 'returns the system command to call' do
        expect(PairUp.expire_command(time_string)).to eql('sleep 28800 && /usr/local/bin/pair --unpair&')
      end
    end

    context 'with a valid integer' do
      let(:time_string) { 8 }
      it 'returns the system command to call' do
        expect(PairUp.expire_command(time_string)).to  eql('sleep 28800 && /usr/local/bin/pair --unpair&')
      end
    end

    context 'with an invalid string' do
      let(:time_string) { 'BAR' }
      it 'raises an error' do
        expect {PairUp.expire_command(time_string)}.to raise_error(StandardError)
      end
    end

  end

  describe '.unpair' do

    let(:pairs) { ['fry', 'leela'] }

    it 'sets the current pair to an empty array' do
      allow(PairUp).to receive(:current_pair=)
      PairUp.unpair
    end

    it 'writes the export file' do
      allow(PairUp).to receive(:write_export_file)
      PairUp.unpair
    end

  end

  describe '.author_command' do

    context 'when pairing' do
      it 'returns the export shell command for GIT_AUTHOR_* and GIT_COMMITTER_*' do
        PairUp.current_pair = ['leela', 'fry']
        expect(PairUp.author_command).to eql("export GIT_AUTHOR_NAME='Turanga Leela' GIT_AUTHOR_EMAIL='leela@futurama.test' GIT_COMMITTER_NAME='Philip J. Fry' GIT_COMMITTER_EMAIL='fry@futurama.test'")
      end

      it 'uses the first pair as author and the second as commiter' do
        PairUp.current_pair = ['fry', 'leela']
        expect(PairUp.author_command).to eql("export GIT_AUTHOR_NAME='Philip J. Fry' GIT_AUTHOR_EMAIL='fry@futurama.test' GIT_COMMITTER_NAME='Turanga Leela' GIT_COMMITTER_EMAIL='leela@futurama.test'")
      end
    end

    context 'when not pairing' do
      it 'returns the unset shell command for GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL' do
        PairUp.current_pair = []
        expect(PairUp.author_command).to eql("unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL")
      end
    end

    context 'with more than 2 developers' do
      it "ignores everyone but the first two" do
        PairUp.current_pair = ['leela', 'fry', 'zoidberg']
        expect(PairUp.author_command).to eql("export GIT_AUTHOR_NAME='Turanga Leela' GIT_AUTHOR_EMAIL='leela@futurama.test' GIT_COMMITTER_NAME='Philip J. Fry' GIT_COMMITTER_EMAIL='fry@futurama.test'")
      end
    end

  end

  describe '.current_pair' do
    it 'returns an array of Github usernames' do
      allow(PairUp).to receive(:config) {config}
      expect(PairUp.current_pair).to eql(['leela', 'fry'])
    end
  end

  describe '.current_pair=' do

    before { allow(PairUp).to receive(:write_file) }

    it 'writes the pair-uprc file' do
      expect(PairUp).to receive(:write_file)
      PairUp.current_pair = ['leela', 'fry']
    end

    context 'when there are no new participants' do
      it 'sets the current pair with the participants given' do
        PairUp.current_pair = ['leela', 'fry']
        expect(PairUp.current_pair).to eql(['leela', 'fry'])
      end
    end

    context 'when there are new participants' do

      let(:new_participant) { 'therubymug' }

      it "prompts for the new participant's info" do
        expect(PairUp::UI).to receive(:prompt_for_pair).with(new_participant)
        PairUp.current_pair = [new_participant, 'fry']
      end

      it 'adds the new participant to current pair' do
        allow(PairUp::UI).to receive(:prompt_for_pair) {new_participant}
        PairUp.current_pair = [new_participant, 'fry']
        expect(PairUp.current_pair).to eql([new_participant, 'fry'])
      end

    end
  end

  describe '.git_author_name' do
    it "returns the first participant's name" do
      allow(PairUp).to receive(:config) { config }
      expect(PairUp.git_author_name).to eql('Turanga Leela')
    end
  end

  describe '.git_author_email' do
    it "returns the first participant's email" do
      allow(PairUp).to receive(:config) { config }
      expect(PairUp.git_author_email).to eql('leela@futurama.test')
    end
  end

  describe '.git_committer_name' do
    it "returns the second participant's name" do
      allow(PairUp).to receive(:config) { config }
      expect(PairUp.git_committer_name).to eql('Philip J. Fry')
    end
  end

  describe '.git_committer_email' do
    it "returns the second participant's email" do
      allow(PairUp).to receive(:config) { config }
      expect(PairUp.git_committer_email).to eql('fry@futurama.test')
    end
  end


end
