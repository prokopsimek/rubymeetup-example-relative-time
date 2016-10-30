Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'send_mail', to: 'application#send_email', as: :send_email

  root 'application#home'
end
