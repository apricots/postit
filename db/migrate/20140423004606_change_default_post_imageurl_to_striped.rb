class ChangeDefaultPostImageurlToStriped < ActiveRecord::Migration
  def change
    change_column :posts, :image_url, :string, :default => "http://i.imgur.com/0QNLAR1.png"
  end
end
