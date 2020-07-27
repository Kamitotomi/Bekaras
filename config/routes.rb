Rails.application.routes.draw do
  
  root 'home#top'
  get 'home/about' => 'home#about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts do
  	 resource :favorites, only: [:create, :destroy]
  	resources :post_comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :index, :edit, :update] do
  	resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
end

end
