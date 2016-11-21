Rails.application.routes.draw do
  get 'game', to: "wordgames#game"

  get 'score', to: "wordgames#score"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
