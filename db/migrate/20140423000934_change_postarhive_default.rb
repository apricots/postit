class ChangePostarhiveDefault < ActiveRecord::Migration
  def change
    change_column :posts, :archive, :boolean, :default => false
  end
end
