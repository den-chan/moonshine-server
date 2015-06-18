require 'faye/websocket'
Faye::WebSocket.load_adapter('thin')
require 'json'
require 'erb'

module Moonshine  
  class Backend
    Peer = Struct.new(:ws, :peer)

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, { ping: 30 })
        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << Peer.new(ws, nil)
        end
        ws.on :message do |event|
          desc = JSON.parse(event.data)
          if desc["type"].eql? "offer"
            if peer = @clients.find {|c| !c.ws.eql? ws }
              @clients.find {|c| c.ws.eql? ws }.peer = peer.ws
              peer.ws.send(event.data)
            end
          elsif desc["type"].eql? "answer"
            peer = @clients.find {|c| c.peer.eql? ws }
            peer.ws.send(event.data) if peer
          end
        end
        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete_if {|c| c.ws.eql? ws }
          ws = nil
        end
        ws.rack_response
      else
        @app.call(env)
      end
    end

    private
    def sanitize(message)
      json = JSON.parse(message)
      json.each {|key, value| json[key] = ERB::Util.html_escape(value) }
      JSON.generate(json)
    end
  end
end