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
    render json: Image.all, except: :_id
  end

end
