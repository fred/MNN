module CarrierWave

  module Uploader
    module Versions
      def recreate_version!(version)
        already_cached = cached?
        cache_stored_file! if !already_cached
        send(version).store!
        if !already_cached && @cache_id
          tmp_dir = File.expand_path(File.join(cache_dir, cache_id), CarrierWave.root)
          FileUtils.rm_rf(tmp_dir)
        end
      end
    end
  end

  if defined?(MiniMagick)
    module MiniMagick
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end
    end
  end
  
  if defined?(RMagick)
    module RMagick
      def quality(percentage)
        manipulate! do |img|
          img.write(current_path){ self.quality = percentage } unless img.quality == percentage
          img = yield(img) if block_given?
          img
        end
      end
    end
  end

end