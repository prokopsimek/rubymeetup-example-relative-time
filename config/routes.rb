Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'send_mail', to: 'application#send_email', as: :send_email
  get 'time', to: 'application#time'

  root 'application#home'
end
