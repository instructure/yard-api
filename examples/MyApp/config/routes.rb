Rails.application.routes.draw do
  resources :shirts do
    post :return
  end

  resources :quizzes do
  	get :permissions
  	get :shirts
  end

  resources :author_slides do
  end
end
