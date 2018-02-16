ActiveAdmin.register Campaign do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
form title: 'Create new Campaign' do |f|
	panel 'Sale Url' do
      div do
        "#{Rails.application.routes.default_url_options[:host]}/home/referral_url_sale_tracking?sale={{token_sale}}"
      end
      div do
        "For example: IF sale is of 1000 tokens then link would be #{Rails.application.routes.default_url_options[:host]}/home/referral_url_sale_tracking?sale=1000"
      end
    end
    inputs 'Details' do
      input :name
      input :total_tokens_to_be_airdropped
      input :tokens_for_each_referral
      input :token_percentage_for_contribution
      input :tokens_to_be_given_to_every_new_user

    end
    actions
  end


permit_params :name, :total_tokens_to_be_airdropped, :tokens_for_each_referral, :token_percentage_for_contribution, :tokens_to_be_given_to_every_new_user

end
