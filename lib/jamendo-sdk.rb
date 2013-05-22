require 'rubygems'
require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'
require 'rexml/document'


# This module defines basic constants used through the whole program
module Jamendo # :nodoc:
    API_SERVER = 'api.jamendo.com'
    WEB_SERVER = 'www.jamendo.com'
    
    API_VERSION = '3.0'
    SDK_VERSION = '0.1.2'

    TEST_CLIENT_ID = 'b6747d04' # You can use this key to test your code
end

class JamendoSession
  attr_accessor :access_plan
  @access_plan = 'r' # Currently defined as read-only
  def initialize(client_id, *access_plan)
    @client_id = client_id
    @access_plan || access_plan
  end
  # Request to Jamendo is expressed like:  
  # http[s]://api.jamendo.com/<version>/<entity>/<subentity>/?<api_parameter>=<value>
  def do_http_authenticated(uri, auth_token, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true    
    begin
      http.request(request)
    rescue => e
      e.inspect
    end    
  end
  
  def do_post(url, headers=nil, body=nil)
    uri = URI.parse(url)
  end
  
  def do_put(url, headers=nil, body=nil)
    uri = URI.parse(url)
  end
  
end

# This class is sending requests to Jamendo and always keeping latest response in self
# you can also set default format for response - by default json
class JamendoRequests
  attr_reader :response
  attr_accessor :format
  
  def initialize(client_id)
    @client_id = client_id
    @format = :json
  end  
  
  # Returns albums by artist (json as default format)
  # date_between: Date format 'yyyy-mm-dd' separated by '_'
  # needed: client id
  # Possible arguments: 
  def albums(artist_name, *args)
    # http://api.jamendo.com/v3.0/albums/?client_id=your_client_id&format=jsonpretty&artist_name=we+are+fm
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&artist_name=#{artist_name}"
    path = __method__.to_s
    http.get(path, query)
  end
  
  # return artist information to client
  def artist(artist_name, *args)
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&name=#{artist_name}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # automatically match any of parameters needed, use prefix as a search parameter
  # set arguments as hash -  possible values:
  # 
  def autocomplete(prefix, *args)
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&limit=3&prefix=#{prefix}&matchcount=1"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # returns playlists
  # datebetween like '2012-01-01_2012-02-01'
  def playlists(name, date_between, format = :json)
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&namesearch=#{name}&datebetween=#{date_between}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  def concerts(*args)
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&name=#{artist_name}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  def radios(*args)
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&name=#{name}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # as Jamendo says, method king. It will take some time to make it complete
  # fuzzy_tags parameter take array of strings
  
  def tracks(*args)
    fuzzy_tags = fuzzy_tags.join('+') unless fuzzy_tags.type_of? String
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&limit=2&fuzzytags=#{fuzzy_tags}&speed=medium+high+veryhigh&include=licenses+musicinfo+stats&groupby=artist_id"
    path = __method__to_s
    http_post(path, query)
  end
  # client_id && (id || access_token || name)
  def users(name)
    # http://api.jamendo.com/v3.0/users/?client_id=your_client_id&format=jsonpretty&name=claudod
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&name#{name}"
    path = __method__to_s
    http_post(path, query)
  end
  
  # Verifies if response from Jamendo servers is correct
  # Uses their own status messages that you can find in this source file
  def assert_response(response)
    
  end
  
  # This method is used for parameters formatting. Don't use it at your own
  # use hash to return parameters string
  def format_parameters(hash) 
    query = ""
    hash.each_with_index do | (param, value), index |
      if value.kind_of? Array
        query << "#{param}=#{value.join(',')}"
      else
        query << "#{param}=#{value}"
      end
      query << "&" unless hash.length - 1 == index
    end
    return query
  end
  
  # gets parameters sent from main method
  # returns formatted response in format you would like to use
  # possible values are: :json, :xml
  def http_get(path, query, format = :json)
    uri = URI.parse ("http://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}/#{path}#{query}")
    puts uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)    
    request = Net::HTTP::Get.new(uri.request_uri)
    begin
      response = http.request(request)
      parse_response(response.body, format)
    rescue => e
      e.inspect      
    end
  end
  
  # These method is only used for write access, so it will check if write access is set inside main class
  def http_post(path, query, format = :json)
    uri = URI.parse ("http://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}" + path + query)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    begin
      response = http.request(request)
      parse_response(response.body, format)
    rescue => e
      e.inspect      
    end
  end  
  
  # Parsing response from server and checking for any kinds of problems with it
  # Returns parse response or error state
  def parse_response(response, type = :json)
    if response.kind_of?(Net::HTTPServerError)
      raise JamendoError.new("Dropbox Server Error: #{response} - #{response.body}", response)
    end
    case type
    when :json
      JSON.parse(response)
    when :xml
      REXML::Document.new(response)
    else
      raise RuntimeError "You are trying to parse unparsable!"
    end
  end
  
end

# This is class that holds Jamendo search parameters
# Initialize it with hash that contains all parameters you need to use for your search
# it will by default initialize all parameters needed for a given Jamendo method
class JamendoParameters
  def initialize(parameters)
    if parameters.kind_of? Hash
      parameters.each do |name, value|
        instance_variable_set("@#{name}", value)
        self.class.__send__(:attr_accessor, "#{name}")
      end
    elsif parameters.kind_of? Array
      parameters.each do | name | 
        instance_variable_set("@#{name}", '')
        self.class.__send__(:attr_accessor, "#{name}")
      end
    end        
  end
  
  # Method that validates all key values from this class
  def validate
    map = ''
  end
end

class OAuthToken
  def initialize(key,secret)
    @key = key
    @secret = secret
  end
end
###############################################################################
# Status messages returned by Jamendo:
# 0	Success	Success (or success with warning)
# 1	Exception	A generic not well identificated error occurred
# 2	Http Method	The received http method is not supported for this method
# 3	Value	One of the received parameters has a value not respecting 
#   requirements such as range, format, etc
# 4	Required Parameter	A required parameter has not been received, or it was 
#   empty
# 5	Invalid Client Id	The client Id received does not exists or cannot be 
#   validated
# 6	Rate Limit Exceeded	This requester app or the requester IP have exceeded the permitted rate limit
# 7	Method Not Found	Jamendo Api rest-like reading methods are in the format 
#   api.jamendo.com/version/entity/subentity (subentity is optional). This exception is raised when entity and/or subentity methods don't exist
# 8	Needed Parameter	A needed parameter has not been received or/and this needed parameter has not the needed value
# 9	Format	This exception is raised when the api call requests an unkown output format
# 10	Entry Point	The used IP and/or port is not recognized as valid entry point
# 11	Suspended Application	The client application has been suspended (illegal usage, ...)
# 12	Access Token	Invalid Access Token.
# 13	Insufficient Scope	Insufficient scope. The request requires higher privileges than provided by the access token
######################################################################################################################
class JamendoError < RuntimeError
  attr_accessor :http_response, :error, :user_error
  def initialize(error, http_response=nil, user_error=nil)
    @error = error
    @http_response = http_response
    @user_error = user_error
  end

  def to_s
    return "#{user_error} (#{error})" if user_error "#{error}"
  end
end

class JamendoAuthError < JamendoError
  # Empty body? Come on!
end