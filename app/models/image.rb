class Image
  include Mongoid::Document
  
  field :original_size, type: String
  field :resizeds, type: Array
end
