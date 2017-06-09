require "ImageService"

class HomeController < ApplicationController

  def index
    begin
    
      ImageService.resize_images()
      render json: {status: 'success'}
      
    rescue Exception => e
      render json: {status: 'error', message: e.message}
    end
  end
  
  def images
    images = Image.all
    
    # convert all path's to url format
    images = images.map do |img|
      img[:original_size] = to_url(img[:original_size])
      
      img[:resizeds].map do |resized| 
        resized[:url] = to_url(resized[:url])
        resized
      end
      img
    end
    
    render json: images, except: :_id
  end
  
  private
  
    def to_url(path)
      "#{request.base_url}/#{path}"
    end

end
