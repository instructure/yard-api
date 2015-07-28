Rails.application.routes.draw do 
  resources :shirts do
    post :return
  end
end
