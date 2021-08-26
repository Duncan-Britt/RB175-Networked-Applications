require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @file_paths = Dir.glob("public/*")
  @file_paths.map! { |path| File.basename(path) }
  @file_paths.sort!

  @order = params['order']
  if @order == 'reverse'
    @file_paths.reverse!
  end

  erb :home
end
