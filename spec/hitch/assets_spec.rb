require 'digest/md5'
require 'spec_helper'

describe Hitch::Assets do

  let (:hitch_path) { File.expand_path("~/.hitch/") }
  let (:gravatar_images_path) { File.expand_path("~/.hitch/gravatar_images/") }

  let (:bender_username) { "oldefortran" } 
  let (:bender_email) { "bend.any.angle@example.com" } 

  let (:zoidberg_username) { "ynotzoidberg" } 
  let (:zoidberg_email) { "zoidberg@example.com" } 

  describe ".avatar_for" do

    context "when there is no ~/.hitch/gravatar_images/ directory" do
      before do
        File.stub(:exists?).and_return true
      end

        it "creates the ~/.hitch/gravatar_images/ directory" do
          Dir.stub(:exist?).with(hitch_path).and_return false
          Dir.stub(:exist?).with(gravatar_images_path).and_return false
          FileUtils.should_receive(:mkdir).with(hitch_path)
          FileUtils.should_receive(:mkdir).with(gravatar_images_path)

          Hitch::Assets.avatar_for(zoidberg_email)
        end

    end

    context "when there is a ~/.hitch/gravatar_images/ directory" do
  
      before do
        Dir.stub(:exist?).with(hitch_path).and_return true
        Dir.stub(:exist?).with(gravatar_images_path).and_return true
      end
  
      context "when there is no gravatar image for user" do
        let(:md5_zoidberg) { Digest::MD5.hexdigest(zoidberg_email) }
        let(:file) { double(:write => true) }
        let(:filename) { File.join(gravatar_images_path, "#{md5_zoidberg}") }
        let(:response) { double(:body => "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\b\x06\x00\x00\x00\x1F\x15\xC4\x89\x00\x00\x00\nIDATx\x9Cc\x00\x01\x00\x00\x05\x00\x01\r\n-\xB4\x00\x00\x00\x00IEND\xAEB`\x82") }
  
        before do
          File.stub(:open).with(filename, 'w').and_return file
          Faraday.stub(:get).with("https://secure.gravatar.com/avatar/#{md5_zoidberg}").and_return response
        end

        it "downloads image from gravatar" do
          Faraday.should_receive(:get).with("https://secure.gravatar.com/avatar/#{md5_zoidberg}").and_return response
          Hitch::Assets.avatar_for(zoidberg_email)
        end
  
        it "saves image to disk as $(md5 email)" do
          file.should_receive(:write)
          File.should_receive(:open).with(filename, 'w').and_return file
          Hitch::Assets.avatar_for(zoidberg_email)
        end
      end
  
    end

  end

  describe ".avatar_for_pair" do
    context "when there is no merged gravatar image for pair" do
      let(:md5_bender) { Digest::MD5.hexdigest(bender_email) }
      let(:md5_zoidberg) { Digest::MD5.hexdigest(zoidberg_email) }
      let(:filename_bender) { File.join(gravatar_images_path, "#{md5_bender}") }
      let(:filename_zoidberg) { File.join(gravatar_images_path, "#{md5_zoidberg}") }

      # xor is used to combine the md5s because it is commutative
      let(:md5_bender_xor_md5_zoidberg) { File.join(gravatar_images_path, (md5_zoidberg.to_i(16)^md5_bender.to_i(16)).to_s(16)) }

      before do
        File.stub(:exists?).with(filename_bender).and_return true
        File.stub(:exists?).with(filename_zoidberg).and_return true
        File.stub(:exists?).with(md5_bender_xor_md5_zoidberg).and_return false
      end
 
      it "merges the gravatars using imagemagick's convert" do
        Kernel.should_receive(:system).with("convert #{filename_zoidberg} #{filename_bender} +append #{md5_bender_xor_md5_zoidberg}")
        Kernel.should_receive(:system).with("convert #{md5_bender_xor_md5_zoidberg} -crop 80x80+40 #{md5_bender_xor_md5_zoidberg}")
        Hitch::Assets.avatar_for_pair(zoidberg_email, bender_email)
      end
    end
  end

end

