# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'rack/protection'
use Rack::Protection::JsonCsrf
use Rack::Protection::EscapedParams
use Rack::Protection::FrameOptions
use Rack::Protection::PathTraversal
use Rack::Protection::IPSpoofing

run Publication::Application
