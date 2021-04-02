Rails.application.routes.draw do
  resources :genres
  root to: 'static_pages#index'

  resources :authors
  resources :books
  resources :pdf_reports, only: [:index, :show] do
    resource :download, only: [:show]
  end

  resources :imports, only: :index
  post '/imports/import', to: 'imports#import'

  resources :static_pages
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
