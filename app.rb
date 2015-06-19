require 'sinatra/base'

module Moonshine
  class App < Sinatra::Base
    set :static => false
    
    get "/" do
      send_file File.join(settings.public_folder, "index.html")
    end
    
    get "/one.txt" do
      response.headers["Access-Control-Allow-Origin"] = "http://den-chan.github.io"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type"
      response.headers["Content-Type"] = "text/plain;charset=utf-8"
      send_file File.join(settings.public_folder, "one.txt")
    end
    
    options "/one.txt" do
      response.headers["Access-Control-Allow-Origin"] = "http://den-chan.github.io"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type"
      response.headers["Content-Type"] = "text/plain;charset=utf-8"
    end
  end
end