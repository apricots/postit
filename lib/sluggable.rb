module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    #expose slug_column
    class_attribute :slug_column
  end


  def to_param
    self.slug
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by slug: the_slug
    count = 2
    while obj && obj != self
      the_slug = append_suffix(the_slug, count)
      obj = self.class.find_by slug: the_slug
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

  #determind which column name to use when making slugs
  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end