class User < ActiveRecord::Base
	has_many :tweets
end	

class Tweet < ActiveRecord::Base
	belongs_to :user
end
