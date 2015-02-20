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
end
