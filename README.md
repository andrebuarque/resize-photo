# resize-photo

## Requirements
- ruby 2.3.*
- rails 5.*
- mongodb
- imagemagick
  - [linux] `sudo apt-get install imagemagick`
  - [macOS] `brew link imagemagick`
  
## How to run the Application

On terminal:

- `git clone https://github.com/andrebuarque/resize-photo.git`
- `cd resize-photo/`
- `bundle`
- `rails s`

Access the url http://localhost:3000/resize-images to resize the images from endpoint.

After, access the url http://localhost:3000/images to list all images with their respective formats.
