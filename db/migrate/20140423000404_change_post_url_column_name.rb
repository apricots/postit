class ChangePostUrlColumnName < ActiveRecord::Migration
  def change
    rename_column :posts, :url, :image_url
  end
end
