require 'spec_helper'

describe PairUp::Participant do

  let(:base_pairs) do
    {
      'bender' => {"email"=>"rcrichoch@fakeinbox.com", "name"=>"Rogelio J. Samour"},
      'fry'    => {"email"=>"crichoch@fakeinbox.com", "name"=>"Phillip J. Fry"},
      'leela'  => {"email"=>"stepriso@fakeinbox.com", "name"=>"Turanga Leela"}
    }
  end

  describe ".write_file" do
    it "writes the contents of PairUp::Participant.available_pairs to the hitch_pairs file" do
      expect(YAML).to receive(:dump)
      PairUp::Participant.write_file
    end
  end

  describe ".add" do

    context "when the participant is not present" do
      it "adds the participant to PairUp::Participant.available_pairs" do
        allow(PairUp::Participant).to receive(:get_available_pairs) { {} }
        PairUp::Participant.add("therubymug", "rcrichoch@fakeinbox.com", "Rogelio J. Samour")
        expect(PairUp::Participant.available_pairs).to eql({"therubymug"=>{"email"=>"rcrichoch@fakeinbox.com", "name"=>"Rogelio J. Samour"}})
      end
    end

  end

  describe ".find" do

    context "when the participant is present" do
      it "and_return the full name" do
        expect(PairUp::Participant.find("therubymug")).to eql({"email"=>"rcrichoch@fakeinbox.com", "name"=>"Rogelio J. Samour"})
      end
    end

    context "when the participant is not present" do
      it "and_return nil" do
        expect(PairUp::Participant.find("nobody")).to be_nil
      end
    end

  end

end
