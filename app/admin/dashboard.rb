ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    panel "User Camapign Details" do
        table_for UserCampaignMapping.all do
            column :id

            column "Camapign Name" do |user_campaign_mapping|
                user_campaign_mapping.campaign.name
            end

            column "User Name" do |user_campaign_mapping|
                user_campaign_mapping.name
            end

            column :email
            column :total_clicked
            column :total_unique_click
            column :ethereum_address
            column :referrals
            column :tokens_earned_through_referrel
            column :total_sale_through_referrel
            column :tokens_earned_through_sale
            column :total_tokens
        end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
    # content
    end
end
