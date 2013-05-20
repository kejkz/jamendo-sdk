require 'rubygems'
require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'

module Jamendo # :nodoc:
    API_SERVER = 'api.jamendo.com'
    WEB_SERVER = 'www.jamendo.com'
    
    API_VERSION = 3
    SDK_VERSION = '0.0.1'

    TEST_CLIENT_ID = 'b6747d04'
end

class JamendoSession
  @access_plan = 'r' # Currently defined as read-only
  def initialize(client_id, access_plan=@access_plan)
    @client_id = client_id
    @access_plan = access_plan
  end
  # Request to Jamendo is expressed like:  
  # http[s]://api.jamendo.com/<version>/<entity>/<subentity>/?<api_parameter>=<value>
  def do_http(uri, auth_token, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    begin
      http.request(request)
    rescue
    end
    
  end
  
  def do_post(url, headers=nil, body=nil)
    uri = URI.parse(url)
  end
  
  def do_put(url, headers=nil, body=nil)
    uri = URI.parse(url)
  end
  
end

class JamendoRequests
  def initialize(client_id)
    @client_id = client_id
    @base_uri =  URI.parse "http://#{Jamendo::API_SERVER}/V#{Jamendo::API_VERSION}.0"
  end
  
  def get_albums(artist_name, format='json')
    # http://api.jamendo.com/v3.0/albums/?client_id=your_client_id&format=jsonpretty&artist_name=we+are+fm
    command = "/albums/?client_id=#{@client_id}&format=#{format}&artist_name=#{artist_name}"
    http = Net::HTTP.new(@base_uri.host, @base_uri.port)
    http.use_ssl = false
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(@base_uri.request_uri + command)
    puts @base_uri.request_uri + command
    request.initialize_http_header( {'User-Agent' => 'Test Script', 'Accept' => 'application/json' } )
    response = http.request(request)
    puts response.body
    puts response.inspect
  end
end

class OAuthToken
  def initialize(key,secret)
    @key = key
    @secret = secret
  end
end
# Status messages returned by Jamendo
# 0	Success	Success (or success with warning)
# 1	Exception	A generic not well identificated error occurred
# 2	Http Method	The received http method is not supported for this method
# 3	Value	One of the received parameters has a value not respecting requirements such as range, format, etc
# 4	Required Parameter	A required parameter has not been received, or it was empty
# 5	Invalid Client Id	The client Id received does not exists or cannot be validated
# 6	Rate Limit Exceeded	This requester app or the requester IP have exceeded the permitted rate limit
# 7	Method Not Found	Jamendo Api rest-like reading methods are in the format api.jamendo.com/version/entity/subentity (subentity is optional). This exception is raised when entity and/or subentity methods don't exist
# 8	Needed Parameter	A needed parameter has not been received or/and this needed parameter has not the needed value
# 9	Format	This exception is raised when the api call requests an unkown output format
# 10	Entry Point	The used IP and/or port is not recognized as valid entry point
# 11	Suspended Application	The client application has been suspended (illegal usage, ...)
# 12	Access Token	Invalid Access Token.
# 13	Insufficient Scope	Insufficient scope. The request requires higher privileges than provided by the access token
class JamendoError < RuntimeError
    attr_accessor :http_response, :error, :user_error
    def initialize(error, http_response=nil, user_error=nil)
        @error = error
        @http_response = http_response
        @user_error = user_error
    end

    def to_s
        return "#{user_error} (#{error})" if user_error
        "#{error}"
    end
end