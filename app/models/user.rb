class User < ActiveRecord::Base; 
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, length: {minimum: 3}
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates_uniqueness_of :username, :case_sensitive => false

  sluggable_column :username
end