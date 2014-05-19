class Post < ActiveRecord::Base
  include Voteable
  include Sluggable

  belongs_to :creator, foreign_key: 'user_id', class_name: "User"
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :user_id, presence: true
  validates :image_url, format: {with: /\.(png|jpg)\Z/i}

  sluggable_column :title


 
end

