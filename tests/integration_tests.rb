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
  
  it "responds with added story title" do
    mailer.deliver_message(:to => 'test@test.com', :subject => "a funny story 'Funny Story!!!'")
    server.tick
    mailer.messages.first.subject.must_equal("Jester saved 'Funny Story!!!'")
  end

  it "responds with all stories" do
    2.times { |i| mailer.deliver_message(:to => 'test@test.com', :subject => "a funny story 'Funny Story #{i}!!!'") }
    server.tick

    mailer.messages.count.must_equal 2

    mailer.deliver_message(:to => 'test@test.com', :subject => "what stories do you know?")
    server.tick

    mailer.messages.first.body.must_include "Funny Story 0!!!\nFunny Story 1!!!"
  end

  it "responds with a sample story to someone genre" do
    2.times { |i| mailer.deliver_message(:to => 'test@test.com', :subject => "a funny story 'Funny Story #{i}!!!'") }
    server.tick

    mailer.deliver_message(:from => 'tester@test.com',
                           :to => 'test@test.com',
                           :subject => "tell something funny to someone@test.com")
    server.tick

    message = mailer.messages.last
    message.to.must_include "someone@test.com"
    message.cc.must_include "tester@test.com"
    message.subject.must_equal "A funny story shared by tester@test.com"
    message.body.match(/Funny Story \d/).wont_be_nil
  end

  it "responds with a sample story to sender by genre" do
    2.times { |i| mailer.deliver_message(:to => 'test@test.com', :subject => "a funny story 'Funny Story #{i}'!!!") }

    mailer.deliver_message(:to => 'test@test.com', :subject => "tell me something funny")
    server.tick

    mailer.messages.last.subject.match(/Funny Story \d/).wont_be_nil
  end

  it "responds with a story by title" do
    mailer.deliver_message(:to => 'test@test.com',
                           :subject => "a funny story 'Funny Story!!!'",
                           :body => "This is a story")

    mailer.deliver_message(:to => 'test@test.com', :subject => "tell me 'Funny Story!!!'")
    server.tick

    mailer.messages.last.body.must_include "This is a story"
  end
end
