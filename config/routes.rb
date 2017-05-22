Rails.application.routes.draw do
  root to: 'word#game'

  get '/score', to: 'word#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
