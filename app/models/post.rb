class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: "User"
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true
  validates :user_id, presence: true

  before_save :generate_slug!

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def to_param
    self.slug
  end

  def generate_slug!
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase
  end

  # deals with slug edge cases with same title
  def append_suffix(str, count)
    # if already appending 2 at the end of slug, then remove and increment next count
    if str.split('-').last.to_i != 0
      return str.split('-').slice(0...-1).join('-') + "-" + count.to_s
    # if first time appending, add -2  
    else
      return str = str + '-2'
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, "-" #regx replaces non alphanumeric chars with -
    str.gsub! /-+/,"-" #gets rid of more than one dash in a row
    str.downcase
  end
end

