Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
	root to: "home#index"
	
  	get 'home/index'

  	get 'home/campaign'

  	post 'home/new_campaign_user'

  	get 'home/referral_url'

  	get 'home/referral_url_unique_click_tracking'

    get 'home/referral_url_sale_tracking'


    get 'home/campaign_ended'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
