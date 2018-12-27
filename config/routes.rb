Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations:      'api/v1/registrations',
        sessions:           'api/v1/sessions'
      }

      resources :users, only: [] do
        collection do
          post :login
          get :login_verify
        end
      end
      resources :trips
    end
  end

end
