class Campaign < ApplicationRecord
	has_many :user_campaign_mappings
end
