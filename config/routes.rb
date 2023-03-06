Rails.application.routes.draw do
  get 'authentication/authenticate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Authentication sign up, sign in
  post '/signup', to: 'authentication#authenticate', defaults: { auth_type: 'signup' }
  post '/signin', to: 'authentication#authenticate', defaults: { auth_type: 'signin' }
end
