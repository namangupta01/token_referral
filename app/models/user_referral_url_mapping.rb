class UserReferralUrlMapping < ApplicationRecord
	belongs_to :user_campaign_mapping

	def redirected_url
		self.user_campaign_mapping.campaign.url
	end
end
