require 'sinatra/base'

module Moonshine
  class App < Sinatra::Base
    enable :logging
    get "/" do
      send_file File.join(settings.public_folder, 'index.html')
    end
  end
end