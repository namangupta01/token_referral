class HomeController < ApplicationController
  def index
  	@campaigns = Campaign.all
  end

  def campaign
  	@campaign = Campaign.where(id: params[:id]).first
  	@user = UserCampaignMapping.new
  end

  def new_campaign_user
  	@new_campaign_user = UserCampaignMapping.new(new_campaign_user_permit_params)
    campaign_id = params[:id].to_i

    unless Campaign.where(id: campaign_id).any?
      redirect_to '/'
    end

  	token = SecureRandom.hex(6)

  	while UserCampaignMapping.where(token: token).any? do 
		  token = SecureRandom.hex(6)
    end
	  @new_campaign_user.token = token
    @new_campaign_user.campaign_id = campaign_id
    @new_campaign_user.save!
  end

  def referral_url
    if user_campaign_valid_token_present?
      user_campaign_mapping = UserCampaignMapping.where(token: params[:token]).first
      user_campaign_mapping.total_clicked = user_campaign_mapping.total_clicked + 1
      user_campaign_mapping.save!
      url = user_campaign_mapping.redirected_url
      unless valid_session_token_already_present?
        user_referral_url = user_campaign_mapping.user_referral_url_mapping.new
        token = SecureRandom.hex(6)
        while UserReferralUrlMapping.where(token: token).any? do
          token = SecureRandom.hex(6)
        end
        user_referral_url.token = token
        user_referral_url.save!
        session[:token] = token
      end
        byebug
        return redirect_to "https://#{url}"
    end
    render :wrong_referral_url
  end

  def referral_url_click_tracking
    if valid_clicked_session_token_already_present?
      user_referral_url = UserReferralUrlMapping.where(token: session[:token]).first
      user_campaign_mapping = user_referral_url.user_campaign_mapping

      unless user_referral_url.clicked == true
        user_campaign_mapping.total_unique_click  = user_campaign_mapping.total_unique_click + 1
        user_campaign_mapping.save!
        user_referral_url.clicked = true
        user_referral_url.save!
      end
      
    end
    send_file("#{Rails.root}/public/small.png",:type => 'image/png', :disposition  =>  'inline', :x_sendfile => true)
  end

  def referral_url_sale_tracking
    if valid_sale_session_token_already_present?
      user_referral_url = UserReferralUrlMapping.where(token: session[:token]).first
      user_campaign_mapping = user_referral_url.user_campaign_mapping
      user_campaign_mapping.total_sale  = user_campaign_mapping.total_sale + 1
      user_campaign_mapping.save!
      user_referral_url.destroy!
      session[:token] = nil
    end
    send_file("#{Rails.root}/public/small.png",:type => 'image/png', :disposition  =>  'inline', :x_sendfile => true)
  end



  private

  def valid_session_token_already_present?
    if session[:token]
      token = session[:token]
      if UserReferralUrlMapping.where(token: token).any?
        if UserReferralUrlMapping.where(token: token).first.user_campaign_mapping.token == params[:token]
          return true
        end
      end
    end
    false
  end

  def valid_clicked_session_token_already_present?
    if session[:token]
      token = session[:token]
      if UserReferralUrlMapping.where(token: token).any?
        return true
      end
    end
    false
  end

  def valid_sale_session_token_already_present?
    if session[:token]
      token = session[:token]
      user_campaign_mapping = UserReferralUrlMapping.where(token: token)
      if user_campaign_mapping.any?
        if user_campaign_mapping.first.clicked == true
          return true
        end
      end
    end
    false
  end

  def new_campaign_user_permit_params
  	params[:user_campaign_mapping].permit(:name,:email)
  end

  def user_campaign_valid_token_present?
    if params[:token]
      if UserCampaignMapping.where(token: params[:token]).any?
        return true
      end
    end
    false
  end

end
