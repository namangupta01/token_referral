Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
	root to: "home#index"
	
  	get 'home/index'

  	get 'home/campaign'

  	post 'home/new_campaign_user'

  	get 'home/referral_url'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
