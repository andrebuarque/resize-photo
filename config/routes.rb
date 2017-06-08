Rails.application.routes.draw do
  get 'resized-images', to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
