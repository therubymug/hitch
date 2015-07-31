require 'digest/md5'

module Hitch
  class Assets
    class << self
      def avatar_for(gravatar_email)
        create_gravatar_images_dir! unless gravatar_images_dir_exists?
        download_gravatar_image!(gravatar_email) unless gravatar_exists_for?(gravatar_email)
        filename(gravatar_email)
      end

      def avatar_for_pair(email1, email2)
        merge_avatars_for_pair!(email1, email2) unless merged_avatar_exists?(email1, email2)
        filename(xor_email_md5s(email1, email2))
      end

      private

      def xor_email_md5s(email1, email2)
        (md5(email1).to_i(16)^md5(email2).to_i(16)).to_s(16)
      end

      def merge_avatars_for_pair!(email1, email2)
        filename1 = File.join(gravatar_images_path, md5(email1))
        filename2 = File.join(gravatar_images_path, md5(email2))
        filename1xor2 = File.join(gravatar_images_path, xor_email_md5s(email1, email2))

        Kernel.system("convert #{filename1} #{filename2} +append #{filename1xor2}")
        Kernel.system("convert #{filename1xor2} -crop 80x80+40 #{filename1xor2}")
      end

      def merged_avatar_exists?(email1, email2)
        avatar1 = avatar_for(email1)
        avatar2 = avatar_for(email2)

        File.exists?(File.join(gravatar_images_path, xor_email_md5s(email1, email2)))
      end

      def gravatar_exists_for?(email)
        File.exists?(filename(email))
      end

      def filename(email)
        File.join(gravatar_images_path, "#{md5(email)}")
      end

      def download_gravatar_image!(email)
        response = Faraday.get("https://secure.gravatar.com/avatar/#{md5(email)}")
        File.open(filename(email), 'w').write(response.body)
      end

      def md5(str)
        Digest::MD5.hexdigest(str)
      end

      def hitch_dir_exists?
        Dir.exist?(hitch_path)
      end

      def gravatar_images_dir_exists?
        hitch_dir_exists? and Dir.exist?(gravatar_images_path)
      end

      def hitch_path
        File.expand_path("~/.hitch/")
      end

      def gravatar_images_path
        File.expand_path("~/.hitch/gravatar_images/")
      end

      def create_hitch_dir!
        FileUtils.mkdir(hitch_path)
      end

      def create_gravatar_images_dir! 
        create_hitch_dir! unless Dir.exist?(hitch_path)
        FileUtils.mkdir(gravatar_images_path)
      end

    end
  end
end

