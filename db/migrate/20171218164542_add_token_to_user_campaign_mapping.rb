class AddTokenToUserCampaignMapping < ActiveRecord::Migration[5.1]
  def change
  	add_column :user_campaign_mappings, :token, :string
  end
end
