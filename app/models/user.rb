class User < ActiveRecord::Base; 
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, length: {minimum: 3}
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates_uniqueness_of :username, :case_sensitive => false
  validates :phone, length: {is: 10}, numericality: { only_integer: true }, allow_blank: true

  sluggable_column :username

  def admin?
    self.role == 'admin'
  end

  def two_factor_auth?
    !self.phone.blank?
  end

  # generates random 6-digit number and automatically hits db
  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    # put your own credentials here 
    account_sid = 'AC86d6066bfd9a5be5705c00e88b175818' 
    auth_token = '423bc7ab833fe9e1987352e941253b31' 

    # set up a client to talk to the Twilio REST API 
    client = Twilio::REST::Client.new account_sid, auth_token 
    number = self.phone
    msg = "Hi. Please input the pin to continue login. Pin: #{self.pin}"
    client.account.messages.create({
    :from => '+16467914343', 
    :to => number, 
    :body => msg,  
    })
  end
end