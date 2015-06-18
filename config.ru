$stdout.sync = true

require './app'
require './backend'
use Moonshine::Backend
require 'rack/ssl-enforcer'
use Rack::SslEnforcer

run Moonshine::App