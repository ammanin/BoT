require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'twilio-ruby'
#require 'dotenv'

# ----------------------------------------------------------------------
# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end


# require any models 
# you add to the folder
# using the following syntax:
# require_relative './models/<model_name>'


# enable sessions for this project
enable :sessions

# put your own credentials here
account_sid = 'AC61d0dcd17dddb54bb7a57c5616e546b8'
auth_token = 'aa8a441c75c6da9fc67a92549448f007'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Twilio.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Twilio::REST::Client.new

get "/" do
  #401
  "I guess it's step 2"
  ENV['TWILIO_NUMBER']
end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------


error 401 do 
  "This worked!!!"
  
end


# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private

# for example 
def square_of int
  int * int
end