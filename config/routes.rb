Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'notification#index'
  get 'get_vapid_keys' => 'notification#get_vapid_keys'

  post '/sendkeys' => 'notification#getJSON', :as => :getJSON
  post '/sendNotification' => 'notification#sendPush', :as => :sendPush

  post '/provide-vapid-key' => 'notification#provide_vapid_key'
end
