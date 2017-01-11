Rails.application.routes.draw do
  resources :users, only: :create

  get '/leaderboard', to: 'users#get_leaderboard'
  post '/update_place', to: 'users#update_place'
end
