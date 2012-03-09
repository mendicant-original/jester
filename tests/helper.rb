gem "minitest" 

require "minitest/autorun"
require "purdytest"
require_relative "../lib/jester"

module Newman
  TEST_DIR   =  File.dirname(__FILE__) 
  DATA_STORE =  TEST_DIR + "/jester.store"

  def self.new_test_server(app)
    server = Newman::Server.test_mode(TEST_DIR + "/settings.rb")
    server.apps << app

    server.settings.application.jester_db = DATA_STORE

    server
  end

  MiniTest::Spec.after do
    File.delete(DATA_STORE) if File.exist?(DATA_STORE)
  end
end

