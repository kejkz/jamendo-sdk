# require 'rubygems'
require 'jamendo-sdk/parameters'
require 'jamendo-sdk/session'
require 'jamendo-sdk/requests'

# This module defines basic constants used through the whole program
module Jamendo
  API_SERVER      = 'api.jamendo.com'
  WEB_SERVER      = 'www.jamendo.com'
  DOWNLOAD_SERVER = 'storage-new.newjamendo.com'
  
  API_VERSION     = '3.0'
  SDK_VERSION     = '0.2'

  TEST_CLIENT_ID  = 'b6747d04' # Use this key to test framework and get methods
end
