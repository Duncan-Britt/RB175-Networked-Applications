require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")

  def print_lines
    string = ''
    @contents.each do |chapter|
      string << "<li class=\"pure-menu-item\"><a href=\"#\" class=\"pure-menu-link\">#{chapter}</a></li>"
    end

    string
  end

  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.readlines("data/chp1.txt", "\n\n")

  erb :chapter
end
