gem "minitest" 

require "minitest/autorun"
require "purdytest"
require_relative "../lib/jester"

module Newman
  TEST_DIR   =  File.dirname(__FILE__) 

  def self.new_test_server(app)
    server = Newman::Server.test_mode(TEST_DIR + "/settings.rb")
    server.apps << app

    data_store = TEST_DIR + "/jester.store"
    File.delete(data_store) if File.exist?(data_store) # Clean db before each test
    server.settings.application.jester_db = data_store

    server
  end
end
