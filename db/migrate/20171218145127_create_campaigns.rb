class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.timestamps
    end
  end
end
