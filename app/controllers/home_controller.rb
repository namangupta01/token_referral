class HomeController < ApplicationController
  def index
  	@campaigns = Campaign.all
  end

  def campaign
  	@campaign = Campaign.where(id: params[:id]).first
    referral_tokens = 0
    if valid_session_token_present_of_particular_campaign?
      referral_tokens = @campaign.tokens_for_each_referral
    end
    if @campaign.total_tokens_to_be_airdropped < @campaign.tokens_used + @campaign.tokens_to_be_given_to_every_new_user + referral_tokens
      return redirect_to '/home/campaign_ended'
    end
  	@user = UserCampaignMapping.new
  end

  def new_campaign_user
    if UserCampaignMapping.where(email: params[:user_campaign_mapping][:email], campaign_id: params[:id].to_i).first
      return redirect_to '/home/campaign?id=' + params[:id], :flash => { error: "Email Already Exist for this Campaign"}
      #flash[:error] = "Email Already Exist for this Campaign"
    elsif UserCampaignMapping.where(ethereum_address: params[:user_campaign_mapping][:ethereum_address], campaign_id: params[:id].to_i).first
      return redirect_to '/home/campaign?id='+ params[:id], :flash => { error: "Ethereum Address already exist"}
      #flash[:error] = "Ethereum Address already exist"
    else
    	@new_campaign_user = UserCampaignMapping.new(new_campaign_user_permit_params)
      campaign_id = params[:id].to_i

      unless Campaign.where(id: campaign_id).any?
        redirect_to '/'
      end

    	token = SecureRandom.hex(6)

    	while UserCampaignMapping.where(token: token).any? do 
  		  token = SecureRandom.hex(6)
      end
      campaign = Campaign.where(id: campaign_id).first
  	  @new_campaign_user.token = token
      @new_campaign_user.campaign_id = campaign_id
      @new_campaign_user.total_tokens = campaign.tokens_to_be_given_to_every_new_user
      if valid_session_token_present?
        user_referral_url = UserReferralUrlMapping.where(token: session[:token]).first
        user_campaign_mapping = user_referral_url.user_campaign_mapping
        @new_campaign_user.referrer_id = user_campaign_mapping.id
        user_campaign_mapping.referrals = user_campaign_mapping.referrals + 1
        user_campaign_mapping.tokens_earned_through_referrel = user_campaign_mapping.tokens_earned_through_referrel + campaign.tokens_for_each_referral
        user_campaign_mapping.total_tokens = user_campaign_mapping.total_tokens + campaign.tokens_for_each_referral
        user_campaign_mapping.save!
      end
      @new_campaign_user.save!
    end
  end

  def referral_url
    if user_campaign_valid_token_present?
      user_campaign_mapping = UserCampaignMapping.where(token: params[:token]).first
      user_campaign_mapping.total_clicked = user_campaign_mapping.total_clicked + 1
      user_campaign_mapping.save!
      url = "#{Rails.application.routes.default_url_options[:host]}/home/campaign?id=#{user_campaign_mapping.campaign.id}"
      unless valid_session_token_for_current_referral_present?
        user_referral_url = user_campaign_mapping.user_referral_url_mapping.new
        token = SecureRandom.hex(6)
        while UserReferralUrlMapping.where(token: token).any? do
          token = SecureRandom.hex(6)
        end
        user_referral_url.token = token
        user_referral_url.save!
        session[:token] = token
      end
        return redirect_to "#{url}"
    end
    render :wrong_referral_url
  end

  def referral_url_unique_click_tracking
    if valid_session_token_present?
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
    if valid_session_token_present?
      user_referral_url = UserReferralUrlMapping.where(token: session[:token]).first
      user_campaign_mapping = user_referral_url.user_campaign_mapping
      unless params[:sale].nil?
        user_campaign_mapping.total_sale_through_referrel = user_campaign_mapping.total_sale_through_referrel + params[:sale].to_i
        tokens_earned = user_campaign_mapping.campaign.token_percentage_for_contribution * (params[:sale].to_i)/100
        user_campaign_mapping.tokens_earned_through_sale = user_campaign_mapping.tokens_earned_through_sale + tokens_earned
        user_campaign_mapping.total_tokens = user_campaign_mapping.total_tokens + tokens_earned
        user_campaign_mapping.save!
      end
    end
    send_file("#{Rails.root}/public/small.png",:type => 'image/png', :disposition  =>  'inline', :x_sendfile => true)
  end


  def campaign_ended


  end



  private

  def valid_session_token_for_current_referral_present?
    if session[:token]
      if UserReferralUrlMapping.where(token: session[:token]).any?
        if UserReferralUrlMapping.where(token: session[:token]).first.user_campaign_mapping.token == params[:token]
          return true
        end
      end
    end
    false
  end

  # def valid_sale_session_token_present?
  #   if session[:token]
  #     token = session[:token]
  #     user_campaign_mapping = UserReferralUrlMapping.where(token: token)
  #     if user_campaign_mapping.any?
  #       if user_campaign_mapping.first.clicked == true
  #         return true
  #       end
  #     end
  #   end
  #   false
  # end

  def new_campaign_user_permit_params
  	params[:user_campaign_mapping].permit(:name,:email, :ethereum_address)
  end

  def user_campaign_valid_token_present?
    if params[:token]
      if UserCampaignMapping.where(token: params[:token]).any?
        return true
      end
    end
    false
  end


  def valid_session_token_present?
    if session[:token]
      if UserReferralUrlMapping.where(token: session[:token]).any?
        return true
      end
    end
    false
  end

  def valid_session_token_present_of_particular_campaign?
    if session[:token]
      if UserReferralUrlMapping.where(token: session[:token]).any?
        if UserReferralUrlMapping.where(token: session[:token]).first.user_campaign_mapping.campaign.id == params[:id].to_i
          return true
        end
      end
    end
    false
  end
end
