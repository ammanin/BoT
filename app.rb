require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'twilio-ruby'
#require 'dotenv'

#Dotenv.load


# ----------------------------------------------------------------------
# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end
=begin
# require any models 
# you add to the folder
# using the following syntax:
# require_relative './models/<model_name>'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Twilio.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Twilio::REST::Client.new
=end


# enable sessions for this project
enable :sessions
client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

get "/" do
	#401
  "Is this you? " +
  ENV['TWILIO_NUMBER']
end

get "/send_sms" do
	client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => "Knock Knock! Reply with Who's there? or Go away"
	)
	"Send Message"
end

get '/incoming_sms' do
	twilm = Twilio::TwiML::Response.new do |r|
		r.Message "BooooYaaaaa!"
	end
	twilm.text
end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------


error 401 do 
  "This worked!!!"
  
end
