class User < ActiveRecord::Base
	has_many :tweets
end	

class Tweet < ActiveRecord::Base
	belongs_to :user
end



class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password 
  #this kind of creates a password outside of the db, since we don't have a column for PW. Until it's quickly run through salt and hash.
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end