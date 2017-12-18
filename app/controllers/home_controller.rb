class HomeController < ApplicationController
  def index
  	@campaigns = Campaign.all
  end

  def campaign
  	@campaign = Campaign.where(id: params[:id]).first
  	@user = UserCampaignMapping.new
  end

  def new_campaign_user
  end
end
