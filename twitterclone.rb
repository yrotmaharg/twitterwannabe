require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

configure( :development) {set :database, "sqlite3:///twitterclone.sqlite3"}

require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require 'rake'

require './models'



enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

#enable :sessions is from sinatra, which is running and has some memory where it stores this info. You shut off your computer, (server) and the session ends.

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
    # this means that during this session, if the user gives back nothing, (it's not the user) then display nothing. If it's the user, then display the
  end
  def display_one
    "1"
  end
end


get '/tweet' do
	haml :tweet
end

get '/signup' do
	haml :signup
end

get '/signin' do
	haml :signin
end


get '/' do
  haml :homepage
end

post '/some_form_submit_route' do
  flash[:alert] = "There was a problem with that."
end

post '/signup' do
  #some code here to process any incoming params
end

post '/signin' do
	#meant to process an incoming sign in, which should contain
	#a username (or email) and password.
	#lookup a user
	#possibly authenticate
	#if a user was found and authenticated, show a flash notice that
	#they were logged in successfuly. then redirect them to the homepage.
  	if @user
  		flash[:notice] = 'Welcome to the homepage'
  		redirect '/'
  	else
  		flash[:alert] = "Uhoh"
  		redirect '/signin'
  	end
  #some code here to process any incoming params
end