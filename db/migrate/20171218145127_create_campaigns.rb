class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.integer :total_tokens_to_be_airdropped, default: 0
      t.integer :tokens_for_each_referral, default: 0
      t.float :token_percentage_for_contribution, default: 0
      t.integer :tokens_to_be_given_to_every_new_user, default: 0
      t.integer :tokens_used, default: 0
      t.timestamps
    end
  end
end
