class ChangePostActiveToArchive < ActiveRecord::Migration
  def change
    rename_column :posts, :active, :archive
  end
end
