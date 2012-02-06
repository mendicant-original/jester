require "bundler"

# normally it's a bad idea to use Bundler as a runtime dependency, but we need
# it here because we're building newman from git.
Bundler.require 

require_relative "jester/story_library"
require_relative "jester/application"
