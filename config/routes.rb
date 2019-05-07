Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'flights#index'
  resources :flights do
    resources :bookings
  end
  get 'transactions', to: 'bookings#index', as: :transactions
end
