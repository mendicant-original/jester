module Jester
  class StoryLibrary
    Story = Struct.new(:genre, :title, :body)

    include Enumerable

    def initialize(filename)
      self.data = Newman::Store.new(filename)
    end

    def add_story(params)
      genre, title, body = params.values_at(:genre, :title, :body)
      data[:stories].create(Story.new(genre, title, body))
    end 

    def each
      data[:stories].each { |e| yield(e.contents) }
    end

    def find_by_title(title)
      story = data[:stories].find { |e| e.contents.title == title }
      
      story.contents if story
    end

    def sample_by_genre(genre)
      data[:stories].select { |e| e.contents.genre == genre }.sample.contents
    end

    private

    attr_accessor :data
  end
end
