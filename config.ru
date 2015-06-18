$stdout.sync = true
require './app'
require './backend'

use Moonshine::Backend

run Moonshine::App