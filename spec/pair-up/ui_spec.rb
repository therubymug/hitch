require 'spec_helper'

describe PairUp::UI do

  describe '.prompt_for_pair' do

    let(:new_author) { 'leela' }
    let(:new_author_name) { 'Turanga Leela' }
    let(:new_author_email) { 'Turanga Leela' }


    before do
      allow(PairUp::UI.highline).to receive(:ask) {new_author_name}
      # expect(PairUp::UI.highline).to receive(:say)
    end

    it 'states that the new pair is not in the pair-up_pairs file' do
      expect(PairUp::UI.highline).to receive(:say).with("I don't know who #{new_author} is.")
      PairUp::UI.prompt_for_pair(new_author)
    end

    it 'prompts for pair' do
      expect(PairUp::UI.highline).to receive(:say)
      expect(PairUp::UI.highline).to receive(:agree).with("Do you want to add #{new_author} to ~/.pair-up_pairs? (yn)")
      expect(PairUp::UI.highline).to receive(:say)
      PairUp::UI.prompt_for_pair(new_author)
    end

    context 'when user does not agree to add new author' do
      it "states it's ignoring the author" do
        allow(PairUp::UI.highline).to receive(:agree) {false}
        expect(PairUp::UI.highline).to receive(:say)
        expect(PairUp::UI.highline).to receive(:say).with("Ignoring #{new_author}.")
        PairUp::UI.prompt_for_pair(new_author)
      end
    end

    context 'when user agrees to add new author' do

      before do
        allow(PairUp::UI.highline).to receive(:agree) {true}
        expect(PairUp::UI.highline).to receive(:say)
      end

      it "asks for the new author's name" do
        expect(PairUp::UI.highline).to receive(:ask).with("What is #{new_author}'s full name?")
        PairUp::UI.prompt_for_pair(new_author)
      end

      it "adds the new author" do
        expect(PairUp::Participant).to receive(:add).with(new_author, new_author_name, new_author_email)
        PairUp::UI.prompt_for_pair(new_author)
      end

      it "writes the ~/.hitch_pairs file" do
        expect(PairUp::Participant).to receive(:write_file)
        PairUp::UI.prompt_for_pair(new_author)
      end

    end

  end

end
