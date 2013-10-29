require 'spec_helper'
require 'stringio'

describe Hitch do
  describe 'configuration file' do
    let(:hitchrc){ Tempfile.new('hitchrc') }

    before do
      described_class.stub(:hitchrc => hitchrc.path)
    end

    def with_custom_input_io(io)
      old_stdin = $stdin
      $stdin = io
      yield
    ensure
      $stdin = old_stdin
    end

    it 'contains the group email address' do
      email = StringIO.new('test@example.com')
      with_custom_input_io(email) do
        described_class.group_email
      end

      hitchrc.read.should include(email.string)
    end
  end
end
