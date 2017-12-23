class CreateUserReferralUrlMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_referral_url_mappings do |t|
    	t.references :user_campaign_mapping
    	t.string :token
    	t.boolean :clicked, default: false
		t.timestamps
    end
  end
end
