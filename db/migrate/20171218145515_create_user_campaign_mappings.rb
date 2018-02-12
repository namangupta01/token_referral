class CreateUserCampaignMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_campaign_mappings do |t|
      t.references :campaign, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.integer :total_clicked, default: 0
      t.string :ethereum_address, null: false
      t.integer :referrer_id, default: 0
      t.integer :referrals, default: 0
      t.timestamps
    end
  end
end
