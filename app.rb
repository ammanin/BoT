require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'twilio-ruby'

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
RESPONSE  = ["Banana","Tunis", "Waiter","To", "Daisy", "Cows go"]
FINAL = ["Banana split so ice creamed.", "Tunis company, three’s a crowd.", "Waiter I get my hands on you.", "To whom. Learn English.", "Daisy me rolling, they hating.", "Cow’s go moo.", ]

get "/" do
	#401
		session["answer_1"] = RESPONSE.sample
		session["x"] = RESPONSE.index(session["answer_1"])
		session["answer_2"] = FINAL[session["x"]]
		message = session["answer_1"]
		"Knock knock!<br> Who's there? <br> #{session["answer_1"]} who? <br> #{session["answer_2"]} "
  #ENV['TWILIO_NUMBER']
end

get "/send_sms" do
	client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => "Knock Knock!"
	)
	"Send Message"
end

get '/incoming_sms' do
	
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
 if body == "hi" or body == "hello" or body == "hey"
    message = get_about_message
 elsif body == "yes"
    session["last_context"] = "play"
    message = "Knock Knock! "
		if body == "who's there?"
		session["answer_1"] = RESPONSE.sample
		session["x"] = RESPONSE.index(session["answer_1"])
		session["answer_2"] = FINAL[session["x"]]
		message = session["answer_1"]
		elsif body == session["answer_1"].downcase + " who?"
		message = session["answer_2"] +"<br> Would you like to play again?"
		session["answer_1"] = ""
		session["answer_2"] = ""
		session["last_context"] = "start"
		end
else

	message = "Come on, you know the game and don't forget about punctuation "
end
=begin
 client.account.messages.create(
	:from => ENV["TWILIO_NUMBER"],
	:to => "+14129548714",
	:body => message
	)
=end
 twiml = Twilio::TwiML::Response.new do |r|
   r.Message message
 end
 twiml.text
	
end


get "/reset" do	
	session["answer_1"]=""
	session["answer_2"]=""
	session["last_context"] = "start"
end


private 


GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", "â€˜Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa"]




def get_greeting
  return GREETINGS.sample
end

def get_about_message
  get_greeting + ", I\'m nok-nok bot. Would you like to read a knock knock joke? Type Yes to play"
end
