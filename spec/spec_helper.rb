require 'rspec'
require 'fileutils'
require 'tempfile'
require 'pry'

require File.join(File.dirname(__FILE__), '..', 'lib', 'hitch')

RSpec.configure do |config|
  config.color = true
  config.formatter = 'progress'
end
