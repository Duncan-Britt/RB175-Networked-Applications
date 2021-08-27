require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index { |line, idx| "<p id=#{idx}>#{line}</p>" }.join
  end

  def highlight(text, term)
    text.gsub(term, "<strong>#{term}</strong>")
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:name" do
  index = params[:name].to_i - 1
  @title = "Chapter #{index + 1}: #{@contents[index]}"

  redirect "/" unless (1..@contents.size).cover? index + 1

  @chapter = File.read("data/chp#{params[:name]}.txt")

  erb :chapter
end

get "/show/:foobar" do
  params[:foobar]
end

not_found do
 redirect "/"
end

def get_chapters_with_phrase(str)
  chapters_with_phrase = {}
  @contents.each_with_index do |chapter, i|
    @chapter = File.read("data/chp#{i + 1}.txt")
    if (@chapter.include? @searched_phrase || "") && @searched_phrase != ""
      chapters_with_phrase[chapter] = i + 1
    end
  end
  chapters_with_phrase
end

get "/search" do
  @searched_phrase = params[:query] || ""

  @chapters = {}
  @contents.each_with_index do |name, i|
    num = i + 1
    paragraphs = File.readlines("data/chp#{num}.txt", "\n\n")
    @chapters[name] = [num, paragraphs]
  end

  @match_chapters = @chapters.select do |name, data|
    paragraphs = data[1]
    paragraphs.any? { |p| p.include? @searched_phrase }
  end

  erb :search
end
