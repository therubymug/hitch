require 'rspec'
require 'fileutils'
require 'tempfile'
require 'faraday'

require File.join(File.dirname(__FILE__), '..', 'lib', 'hitch')

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = 'progress'
  config.before(:each) do
    Hitch.stub(:hitchrc).and_return(Tempfile.new('hitchrc').path)
    Hitch.stub(:hitch_export_authors).and_return(Tempfile.new('hitch_export_authors').path)
    Hitch::Author.stub(:hitch_pairs).and_return(Tempfile.new('hitch_pairs').path)
  end
end
