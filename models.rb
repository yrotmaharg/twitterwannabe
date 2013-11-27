class User < ActiveRecord::Base
    
  def full_name
    if fname && lname
        fname + ' ' + lname
    elsif fname
        fname
    elsif lname
        lname
    else
        nil
    end
  end


    #attr_accessible :email, :password, :password_confirmation     (copied from http://railscasts.com/episodes/250-authentication-from-scratch, but causing following error: `attr_accessible` is extracted out of Rails into a gem. Please use new recommended protection model for params(strong_parameters) or add `protected_attributes` to your Gemfile to use old one. (RuntimeError)
#)
  
  attr_accessor :password 
  #this kind of creates a password outside of the db, since we don't have a column for PW. Until it's quickly run through salt and hash.
  before_save :encrypt_password
  
  #validates_confirmation_of :password 
  #if you had a PW conf field
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  #the "self" makes it a class method. here self is referring to the User class above

  def self.authenticate(email, password)
    user = find_by_email(email) #or User.where(email: email).first - looking up a user by the assigned email.
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  # this is an instance method.
  def encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
	has_many :tweets
end	


class Tweet < ActiveRecord::Base
	belongs_to :user
end


