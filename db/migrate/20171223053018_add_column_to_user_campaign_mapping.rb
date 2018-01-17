class AddColumnToUserCampaignMapping < ActiveRecord::Migration[5.1]
  def change
  	add_column :user_campaign_mappings, :total_sale, :integer, default: 0
  	add_column :user_campaign_mappings, :total_unique_click, :integer, default: 0
  end
end
