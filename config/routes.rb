Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :users, only: [] do
        collection do
          post :login
          get :login_verify
        end
      end
    end
  end

end
