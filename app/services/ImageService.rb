require 'net/http'
require 'fileutils'

class ImageService

  ENDPOINT = 'http://54.152.221.29/images.json'
  ROOT_DIR = "#{Rails.root}/public/images"
  FORMATS = ['320x240', '384x288', '640x480']

  def self.resize_images
    images = self.find_images

    images.each do |image_url|
      document = self.save_on_disk(image_url)
      self.save_on_db(document) unless document.nil?
    end
  end

  private

    def self.find_images
      JSON.parse(Net::HTTP.get(URI ENDPOINT))['images'].map do |img| 
        img['url']
      end
    end

    def self.save_on_disk(image_url)
      document = {}
      file_name = File.basename image_url, '.jpg'
      dir = "#{ROOT_DIR}/#{file_name}"

      response = Net::HTTP.get(URI image_url)

      FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      file_path = "#{dir}/original.jpg"
      temp_path = "/tmp/tmp.jpg"

      open(temp_path, "wb") do |io|
        io.write response
      end
      
      return if File.exists?(file_path) && FileUtils.identical?(temp_path, file_path)
      
      Image.where(original_size: file_path).destroy
      
      # original file
      document[:original_size] = file_path[file_path.index("images/")..-1]
      original_file = open(file_path, "wb")
      original_file.write response
      original_file.close
      
      document[:resizeds] = []
      FORMATS.each { |format| 
        document[:resizeds] << { format: format, url: format_image(file_path, format) } 
      }
      
      document
    end

    def self.format_image(file_path, format)
      new_path = File.dirname(file_path) + "/#{format}.jpg"
      
      image = MiniMagick::Image.open(file_path)
      image.resize format
      image.format 'jpg'
      image.write(new_path)
      
      new_path
    end
    
    def self.save_on_db(document)
      Image.create(document)
    end
end