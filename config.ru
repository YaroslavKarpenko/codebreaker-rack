# frozen_string_literal: true

require_relative 'lib/autoloader'

use Rack::Reloader
use Rack::Static, urls: ['/assets'], root: 'lib/views'
use Rack::Session::Cookie, key: 'rack.session', secret: 'secret'

run Application
