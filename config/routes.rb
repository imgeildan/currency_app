Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #root 'currencies#index'
  resources :currencies, only: %w[index create], :path => '/' do
  	post :fetch_data, on: :collection
  end
end
