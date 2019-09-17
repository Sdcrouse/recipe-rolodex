class ChangeTypeOfImageUrlToText < ActiveRecord::Migration
  def change
    change_column :recipes, :image_url, :text
  end
end
