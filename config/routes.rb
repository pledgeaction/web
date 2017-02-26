Rails.application.routes.draw do
  resource :sms do
    collection do
      post 'checkin'
    end
  end

  get '/' => 'home#home', :as => 'root'
  get '/success' => 'home#success'

  get 'u/:id' => 'user#view'
  get '/ref' => 'user#ref'

  post 'import/typeform' => 'import#typeform'
end
