class HomeController < ApplicationController
  def index
  	@campaigns = Campaign.all
  end

  def campaign
  end

  def new_campaign_user
  end
end
