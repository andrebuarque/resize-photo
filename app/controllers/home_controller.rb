require "ImageService"

class HomeController < ApplicationController

  def index
    ImageService.resize_images()
    images = ImageService.get_images().map do |items| 
      items.map { |img| "#{request.base_url}/#{img}" }  
    end

    render json: images
  end

end
