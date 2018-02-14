class Campaign < ApplicationRecord
	has_many :user_campaign_mappings
	validates :name, presence: true
	validate :valid_token_for_each_referral
	validate :valid_token_percentage_for_contribution
	validate :valid_tokens_to_be_given_to_every_new_user

	def valid_token_for_each_referral
		unless total_tokens_to_be_airdropped >= tokens_for_each_referral
			errors.add(:tokens_for_each_referral, "referral tokens cannot execced total tokens ")
		end
	end

	def valid_token_percentage_for_contribution
		unless token_percentage_for_contribution <= 100
			errors.add(:token_percentage_for_contribution, "percentage can't execced 100")
		end
	end

	def valid_tokens_to_be_given_to_every_new_user
		unless total_tokens_to_be_airdropped >= tokens_to_be_given_to_every_new_user
			errors.add(:tokens_to_be_given_to_every_new_user, "tokens cannot execced total tokens ")
		end

	end

end
