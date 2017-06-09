Rails.application.routes.draw do
  get 'resize-images', to: 'home#index'
  get 'images', to: 'home#images'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
