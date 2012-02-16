require_relative 'helper'

describe "Jester" do
  let(:server) { Newman.new_test_server(Jester::Application) }
  let(:mailer) { server.mailer }
  
  it "responds with a help document" do
    mailer.deliver_message(:to => 'test@test.com', :subject => 'help')
    server.tick
    mailer.messages.first.subject.must_equal("How to use Jester")
  end
  
  it "responds with failure message when the subject does not match" do
    mailer.deliver_message(:to => 'test@test.com')
    server.tick
    mailer.messages.first.subject.must_equal("Sorry, didn't understand your request")
  end
  
end