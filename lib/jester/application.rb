module Jester
  Application = Newman::Application.new do

    helpers do
      def story_library
        Jester::StoryLibrary.new(settings.application.jester_db)
      end
    end

    match :genre, '\S+'
    match :title, '.*'
    match :email, '[\w\d\._-]+@[\w\d\._-]+' #not legit, I'm sure

    subject(:match, "a {genre} story '{title}'") do
      story_library.add_story(:genre => params[:genre],
                              :title => params[:title],
                              :body  => request.body.to_s)

      respond :subject => "Jester saved '#{params[:title]}'"
    end

    subject(:match, "what stories do you know?") do
      respond :subject => "All of Jester's stories",
              :body    => story_library.map { |e| e.title }.join("\n")
    end

    subject(:match, "tell something {genre} to {email}") do
      story = story_library.sample_by_genre(params[:genre])

      respond :subject => "A #{params[:genre]} story shared by #{request.from.first}",
              :to      => params[:email],
              :cc      => request.from,
              :body    => "#{story.title}\n\n#{story.body}"

    end

    subject(:match, "tell me something {genre}") do
      story = story_library.sample_by_genre(params[:genre])

      respond :subject => story.title, 
              :body    => story.body
    end

    subject(:match, "tell me '{title}'") do
      story = story_library.find_by_title(params[:title])

      if story
        respond :subject => story.title, :body => story.body
      else
        respond :subject => "Couldn't find '#{params[:title]}'",
                :body    => "Sorry about that!"
      end
    end

    subject(:match, "help") do
      respond :subject => "How to use Jester",
              :body    => "You can find out about how jester works at: "+
                          "http://github.com/mendicant-university/jester"
    end

    default do
      respond :subject => "Sorry, didn't understand your request"
    end
  end
end
