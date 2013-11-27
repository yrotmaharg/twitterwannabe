require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

configure(:development){ set :database, "sqlite3:///twitterclone.sqlite3" }
#set is a method,so don't forget a space (or parenthesis)

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'bcrypt'
require 'rake'

require './models'


#stuff you need for the flash
enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

#enable :sessions is from sinatra, which is running and has some memory where it stores this info. You shut off your computer, (server) and the session ends.

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
    # this means that during this session, if the user gives back nothing, (it's not the user) then display nothing. If it's the user, then display the
  #you could also code this like this:
  #if session[:user_id]
    #User.find(session[:user_id])
    #else 
    #nil
    #end
  end
  def display_one
    "1"
  end
end


get '/' do
  @users = User.all
  @tweets = Tweet.all
  haml :home
end

#why do these get defined here? in the home route?


get '/tweet' do
	haml :tweet
end

get '/signup' do
	haml :signup
end

get '/signin' do
	haml :signin
end




post '/some_form_submit_route' do
  flash[:alert] = "There was a problem with that."
end



post '/signup' do
  #some code here to process any incoming params
	@user = User.new(params['user'])
	if @user.save
		flash[:notice] = "You have signed up successfully"
		redirect '/'
	else
		 flash[:alert] = "Oh oh. That didn't work. Try again."
		 redirect '/signup'
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  haml :profile
end

post '/signin' do
	#meant to process an incoming sign in, which should contain
	#a username (or email) and password.
	#lookup a user
	#possibly authenticate
	#if a user was found and authenticated, show a flash notice that
	#they were logged in successfuly. then redirect them to the homepage.
  @user = User.authenticate(params['user']['email'], params['user']['password'])

  	if @user
      session[:user_id] = @user.id
  		flash[:notice] = 'Welcome!'
  		redirect '/'
  	else
  		flash[:alert] = "Ooops! That didn't work."
  		redirect '/signin'
  	end
  #some code here to process any incoming params
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You've been successfully signed out."
  redirect '/'
end

post '/tweet/new' do
  if current_user
    @tweet = Tweet.new(text: params['text'], created_at: Time.now, user_id: current_user.id)
    if @tweet.save
      flash[:notice] = "YAY"
    else
    flash[:alert] = "Ooops"
    end
    redirect "/users/#{current_user.id}"
  end
end



