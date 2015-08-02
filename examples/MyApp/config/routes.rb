Rails.application.routes.draw do
  resources :shirts do
    post :return
  end

  resources :quizzes do
  	get :permissions
  	get :shirts
  end

  resources :author_slides

  resources :accounts
  resources :tags do
    [
      :throws,
      :note,
      :warning
    ].each do |endpoint|
      get endpoint
    end
  end
end
