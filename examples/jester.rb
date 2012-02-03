require_relative "../lib/jester"

Newman::Server.simple(Jester::Application, "config/environment.rb")
