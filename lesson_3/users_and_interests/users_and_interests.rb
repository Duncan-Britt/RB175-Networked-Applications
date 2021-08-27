require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require 'yaml'

# {
#   :jamy => {
#     :email =>"jamy.rustenburg@gmail.com",
#     :interests=> ["woodworking", "cooking", "reading"]
#     },
#   :nora => {
#     :email => "nora.alnes@yahoo.com",
#     :interests => ["cycling", "basketball", "economics"]
#     },
#   :hiroko => {
#     :email => "hiroko.ohara@hotmail.com",
#     :interests => ["politics", "history", "birding"]
#     }
# }

before do
  @user_data = YAML.load(File.read("data/users.yaml"))
end

helpers do
  def count_users
    @user_data.size
  end

  def count_interests
    @user_data.values.reduce(0) do |acc, data|
      data[:interests].size + acc
    end
  end
end

get "/" do
  erb :home
end

get "/user/:name" do
  @name = params[:name].to_sym
  @interests = @user_data[@name][:interests].map(&:capitalize).join(', ')
  @other_users = @user_data.keys.reject { |user| user == @name }
  erb :user
end
