class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :tokens_to_be_airdropped, default: 0
      t.integer :tokens_distributed_for_each_referral, default: 0
      t.integer :token_percentage_for_each_contribution, default: 0
      t.timestamps
    end
  end
end
