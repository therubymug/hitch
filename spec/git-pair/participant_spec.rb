require 'spec_helper'

describe Hitch::Participant do

  let(:base_pairs) do
    {
      'bender' => {"email"=>"rcrichoch@fakeinbox.com", "name"=>"Rogelio J. Samour"},
      'fry' => {"email"=>"crichoch@fakeinbox.com", "name"=>"Phillip J. Fry"},
      'leela' => {"email"=>"stepriso@fakeinbox.com", "name"=>"Turanga Leela"}
    }
  end

  before { Hitch::Participant.stub(:available_pairs).and_return(base_pairs) }

  describe ".write_file" do
    it "writes the contents of Hitch::Participant.available_pairs to the hitch_pairs file" do
      YAML.should_receive(:dump)
      Hitch::Participant.write_file
    end
  end

  describe ".add" do

    before { Hitch::Participant.stub(:available_pairs).and_return({}) }

    context "when the participant is not present" do
      it "adds the participant to Hitch::Participant.available_pairs" do
        Hitch::Participant.add("therubymug", "rcrichoch@fakeinbox.com", "Rogelio J. Samour")
        expect(Hitch::Participant.available_pairs).to eql({"therubymug"=>{"email"=>"rcrichoch@fakeinbox.com", "name"=>"Rogelio J. Samour"}})
      end
    end

  end

  describe ".find" do

    context "when the participant is present" do

      before do
        Hitch::Participant.stub(:available_pairs).and_return({"therubymug" => "Rogelio J. Samour"})
      end

      it "and_return the full name" do
        expect(Hitch::Participant.find("therubymug")).to eql("Rogelio J. Samour")
      end

    end

    context "when the participant is not present" do
      it "and_return nil" do
        expect(Hitch::Participant.find("nobody")).to be_nil
      end
    end

  end

end
