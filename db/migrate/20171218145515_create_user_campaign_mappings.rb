class CreateUserCampaignMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_campaign_mappings do |t|
      t.references :campaign, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.integer :total_clicked, default: 0
      t.integer :total_unique_click, default: 0
      t.string :ethereum_address, null: false
      t.integer :referrer_id, default: 0
      t.integer :referrals, default: 0
      t.integer :tokens_earned_through_referrel, default: 0
      t.integer :total_sale_through_referrel, default: 0
      t.integer :tokens_earned_through_sale, default: 0
      t.integer :total_tokens, default: 0
      t.timestamps
    end
  end
end
