require 'net/http'
require 'fileutils'

class ImageService

  ENDPOINT = 'http://54.152.221.29/images.json'
  ROOT_DIR = "#{Rails.root}/public/images"
  FORMATS = ['320x240', '384x288', '640x480']

  def self.resize_images
    images = self.find_images

    images.each do |image_url|
      self.save_image(image_url)
    end

  end

  def self.get_images
    Dir.glob("#{ROOT_DIR}/**/*").
        select { |path| File.file?(path) }. # excludes directories from paths list. considers only files paths
        map { |path| path[path.index("images/")..-1] }. # gets relative path (e.g: /images/NAME_FROM_ENDPOINT/640x480.jpg)
        group_by { |path| path.split('/')[1] }. # group by name of file
        map { |key, img| img }
  end

  private

    def self.find_images
      JSON.parse(Net::HTTP.get(URI ENDPOINT))['images'].map do |img| 
        img['url']
      end
    end

    def self.save_image(image_url)
      file_name = File.basename image_url, '.jpg'
      dir = "#{ROOT_DIR}/#{file_name}"

      response = Net::HTTP.get(URI image_url)

      FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      file_path = "#{dir}/original.jpg"

      # original file
      open(file_path, "wb") do |io|
        io.write(response)
      end

      FORMATS.each { |format| 
        format_image(file_path, format) 
      }

    end

    def self.format_image(file_path, format)
      image = MiniMagick::Image.open(file_path)
      image.resize format
      image.format 'jpg'
      image.write(File.dirname(file_path) + "/#{format}.jpg")
    end
end