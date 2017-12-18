class UserCampaignMapping < ApplicationRecord
	belongs_to :campaign
	has_many :user_referral_url_mapping

	def redirected_url
		self.campaign.url
	end

end
