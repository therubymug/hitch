require 'spec_helper'

describe Hitch::Author do

  let(:base_pairs) do
    {
      'bender' => 'Bender Bending Rodriguez',
      'fry' => 'Phillip J. Fry',
      'leela' => 'Turanga Leela'
    }
  end

  before { Hitch::Author.stub(:available_pairs).and_return(base_pairs) }

  describe ".write_file" do
    it "writes the contents of Hitch::Author.available_pairs to the hitch_pairs file" do
      YAML.should_receive(:dump)
      Hitch::Author.write_file
    end
  end

  describe ".add" do

    before { Hitch::Author.stub(:available_pairs).and_return({}) }

    context "when the author is not present" do
      it "adds the author to Hitch::Author.available_pairs" do
        Hitch::Author.add("therubymug", "Rogelio J. Samour")
        Hitch::Author.available_pairs.should == {"therubymug" => "Rogelio J. Samour"}
      end
    end

  end

  describe ".find" do

    context "when the author is present" do

      before do
        Hitch::Author.stub(:available_pairs).and_return({"therubymug" => "Rogelio J. Samour"})
      end

      it "and_return the full name" do
        Hitch::Author.find("therubymug").should == "Rogelio J. Samour"
      end

    end

    context "when the author is not present" do
      it "and_return nil" do
        Hitch::Author.find("nobody").should be_nil
      end
    end

  end

end
