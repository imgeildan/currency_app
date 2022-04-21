require 'resque/server'
require 'resque/scheduler/server'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #root 'currencies#index'
  mount Resque::Server.new, at: "/resque"

  resources :currencies, only: %w[index create], path: '/' do
  	put :fetch_data, on: :collection
  end
end
