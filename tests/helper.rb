gem "minitest" 

require "minitest/autorun"
require "purdytest"
require_relative "../lib/jester"

module Newman
  TEST_DIR   =  File.dirname(__FILE__) 

  def self.new_test_server(app)
    server = Newman::Server.test_mode(TEST_DIR + "/settings.rb")
    server.apps << app
    server.settings.application.jester_db = TEST_DIR + "/jester.store"
    server.settings.service.templates_dir = TEST_DIR + "/../examples/views"

    server
  end
end