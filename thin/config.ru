require 'lib/sinatra/lib/sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :development
)
 
require 'web_app'
run Sinatra.application
