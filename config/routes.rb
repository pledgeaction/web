Rails.application.routes.draw do
  get '/' => 'home#home', :as => 'root'
  get '/success' => 'home#success'

  get 'u/:id' => 'user#view'

  post 'import/typeform' => 'import#typeform'
end
