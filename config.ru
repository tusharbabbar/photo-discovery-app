require 'sinatra'
 
#Sinatra::Application.default_options.merge!(
#  :run => false,
#  :env => :development
#)
 
require '~/photo-discovery-server/web_app'
run Sinatra.application
