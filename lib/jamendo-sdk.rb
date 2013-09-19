require 'rubygems'
require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'
require 'rexml/document'

# This module defines basic constants used through the whole program
module Jamendo
  API_SERVER = 'api.jamendo.com'
  WEB_SERVER = 'www.jamendo.com'
  DOWNLOAD_SERVER = 'storage-new.newjamendo.com'
  
  API_VERSION = '3.0'
  SDK_VERSION = '0.2'

  TEST_CLIENT_ID = 'b6747d04' # Use this key to test framework and get methods
end

# Sending requests to Jamendo - keeps last response in self (read-only)
# you can also set default format for response - by default json
# Access token set to nil because it's not used by most read-only requests
class JamendoRequests
  attr_reader :result
  attr_accessor :format, :access_token, :client_id, :parameters 
  
  @callback_status = false
  
  # Initialize JamendoRequests object. Callback and access token set to nil by default
  def initialize(client_id, access_token=nil, callback=nil)
    @client_id = client_id
    @access_token = access_token
    @format = :json
    @callback = callback
  end
  
  # used to set calback response string for jsonp technique
  def set_callback(string, set_callback_status)
    @callback = string
    @callback_status = true if set_callback_status
  end  
  
  # Returns albums by artist (json as default format)
  # send hash of values you want to search for or use pre-defined hashes
  # Possible parameters:
  # General:   
  # offset - skip first n values
  # limit - limit to n entries
  # order - name, id, releasedate, artist_id, artist_name, popularity_total, popularity_month, popularity_week
  # # __albums__ - !note!: parameters are considered as AND
  # id = array of artist id's
  # name = album name
  # namesearch = name to search for   
  # artist_name - name of artist you are searching
  # __filered___
  # date_between: Date format 'yyyy-mm-dd' separated by '_'
  # __optional__
  # imagesize = size of images to return - {25, 35, 50, 55, 60, 65, 70, 75, 85, 100, 130, 150, 200, 300, 400, 500, 600}
  # audioformat = mp32 - only viable format currently
  def albums(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # Get tracks of selected album
  def albums_tracks(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    http_get(path, query)
  end
  
  def albums_musicinfo(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    http_get(path, query)
  end
  
  # You can call this method to be re-directed to access file of any kind via http on Jamendo
  # form: # http://storage-new.newjamendo.com/download/track/145317/mp31/
  # possible values: :albums, :tracks, :playlists
  def file(file_type, id)
    query = "/?client_id=#{@client_id}&#{id}"
    path = "#{file_type}/#{__method__}.to_s"
    resp = http_get(path, query)
  end      
  
  # return artist information to client
  # arguments have to be hash of parameter values
  def artists(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  def artists_tracks(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    resp = http_get(path, query)
  end
  
  def artists_albums(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    resp = http_get(path, query)
  end
  
  # too much similar methods to my liking... looks like I will have to make it more dynamic
  def artists_locations(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    resp = http_get(path, query)
  end
  
  def artists_musicinfo(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s.gsub(/[_]/,'/')
    resp = http_get(path, query)
  end
  
  # automatically match any of parameters needed, use prefix as a search parameter
  # set arguments as hash -  possible values:
  # 
  def autocomplete(prefix, args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&prefix=#{prefix}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # returns playlists
  # datebetween like '2012-01-01_2012-02-01'
  def playlists(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  def concerts(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  def radios(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # as Jamendo says, method king. It will take some time to make it complete
  def tracks(args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&#{format_parameters(args)}"
    path = __method__.to_s
    http_get(path, query)
  end
  
  # client_id && (id || access_token || name)
  def users(name, args={})
    query = "/?client_id=#{@client_id}&format=#{format.to_s}&name#{name}"
    path = __method__.to_s
    http_post(path, query)
  end
  
  # Method for searching through Jamendo database
  # type: :album, :artist, :track, :playlists
  # search_for: string of your liking
  # order: 
  def name_search( type, search_for, order_by = 'name' )
    self.send(type.to_sym, { namesearch: search_for, order: order_by })
  end
  
  # Verifies if response from Jamendo servers is correct
  # Uses their own status messages that you can find in this source file
  def assert_response(resp_headers)
    if resp_headers[:status] == 'success' 
      return true
    elsif resp_headers[:status] == 'false'
      raise JamendoError.new(resp_headers[:error_message], nil, nil, resp_headers[:code])
      return false
    else
      raise JamendoError.new('Could not assert response!')
    end
  end
  
  # This method is used for parameters formatting. Don't use it at your own
  # use hash to return parameters string
  def format_parameters(parameters={})
    raise JamendoError.new("Please provide hash!") unless parameters.kind_of?(Hash)
    query = ""
    parameters.each_with_index do | (param, value), index |
      if value.kind_of?(Array)
        query << "#{param}=#{CGI.escape(value.join(' ').squeeze(' '))}"
      else
        query << "#{param}=#{CGI.escape(value.to_s.squeeze(' '))}"
      end
      query << "&" unless parameters.length - 1 == index
    end
    return query
  end
  
  # http get request to Jamendo 
  # returns formatted response in format set in class constructor
  def http_get(path, query, format = :json)
    uri = URI.parse("http://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}/#{path}#{query}")
    puts uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)    
    request = Net::HTTP::Get.new(uri.request_uri)
    begin
      response = http.request(request)
      result = parse_response(response)
      assert_response(result[:headers])
      return result[:results]
    rescue JamendoError => e
      e.inspect
    end
  end
  
  # These method is only used for write access, so it will check if write access is set inside main class
  def http_post(path, query, format = :json)
    raise JamendoError.new('Please authenticate application before posting!') if @access_token.nil?
    uri = URI.parse("http://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}/?client_id=#{@client_id}&format=#{format.to_s}&#{path}#{query}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    begin
      response = http.request(request)
      parse_response(response)
    rescue => e
      e.inspect      
    end
  end  
  
  # Parsing response from server and checking for any kinds of problems with it
  # Returns json respone hash or rexml document
  def parse_response(response)
    if response.kind_of?(Net::HTTPServerError)
      raise JamendoError.new("Jamendo Server Error: #{response} - #{response.body}", response)
    end
    
    case @format
    when :json
      JSON.parse(response.body, symbolize_names: true)
    when :xml
      REXML::Document.new(response.body)
    else
      raise JamendoError.new('You are trying to parse unparsable!')
    end
  end  
  
  # Method that is validating parameters and checking for object format
  # This method is gateway for correctly setting parameters
  def validate_parameters(sent_parameters)
    valid_parameters = nil
    if sent_parameters.is_a?(JamendoParameters)
      valid_parameters = sent_parameters.to_hash
    elsif sent_parameters.is_a?(Hash)
      valid_parameters = format_parameters(sent_parameters)
    elsif sent_parameters.is_a?(String)
      valid_parameters = Hash.new
      valid_parameters = { artist: sent_parameters }
    else
      raise JamendoError("Imposible to handle parameter you provided.")
    end
    return valid_parameters
    #sent_parameters.select! { | param, value | valid_parameters.include?(param) }
  end
  
end

# This is class that holds Jamendo search parameters
# Initialize it with hash that contains all parameters you need to use for your search
# it will by default initialize all parameters needed for a given Jamendo method
class JamendoParameters
  def initialize(parameters)
    if parameters.kind_of? Hash
      parameters.each do |name, value|
        instance_variable_set("@#{name}", value.to_s)
        self.class.__send__(:attr_accessor, "#{name}")
      end
    elsif parameters.kind_of? Array
      parameters.each do | name | 
        instance_variable_set("@#{name}", '')
        self.class.__send__(:attr_accessor, "#{name}")
      end
    end
  end
  
  def to_hash
    Hash[instance_variables.map { |var| [var[1..-1].to_sym, instance_variable_get(var)] }]
  end
  
  # Method that validates all key values from this class against parameters that they can use
  # This method is convenient to clear all values values that are not needed in Jamendo requests
  # !!!Still does not work!!!
  def validate!(call_name)
    params = self.methods
    params.select { | method | call_name.include?(call_name) }
  end

  # Display your object as a nice list of parameters
  def to_s
    self.methods.each { |m| puts self.m }
  end
end

class OAuthToken
  def initialize(key,secret)
    @key = key
    @secret = secret
  end
end

# Class that will define part-downloader
# Send url from Jamendo :audio tag
# http://storage-new.newjamendo.com/download/track/145317/mp31/
class JamendoDownloader
  def self.download(url, local_path)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port) do | http |
      begin
        file = open(local_path, 'wb')
        http.request_get(uri.path) do | response |
          response.read_body do |segment|
            file.write(segment)
          end
        end
      ensure
        file.close
      end
    end
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
  attr_accessor :http_response, :error, :user_error, :error_code
  def initialize(error, http_response=nil, user_error=nil, error_code=nil)
    @error = error
    @http_response = http_response
    @user_error = user_error
    @error_code = error_code.to_i
  end
  
  def encode_errors
    case @error_code
    when 1
      return "Exception\nA generic not well identificated error occurred"
    when 2
      return "Http Method\nThe received http method is not supported for this method"
    when 3
      return "Value\nOne of the received parameters has a value not respecting requirements such as range, format, etc"
    when 4
      return "Required Parameter\nA required parameter has not been received, or it was empty"
    when 5
      return "Invalid Client Id\nThe client Id received does not exists or cannot be validated"
    when 6
      return "Rate Limit Exceeded\nThis requester app or the requester IP have exceeded the permitted rate limit"
    when 7
      return "Method Not Found\nJamendo Api rest-like reading methods are in the format api.jamendo.com/version/entity/subentity (subentity is optional). This exception is raised when entity and/or subentity methods don't exist"
    when 8
      return "Needed Parameter\nA needed parameter has not been received or/and this needed parameter has not the needed value"
    when 9
      return "Format\nThis exception is raised when the api call requests an unkown output format"
    when 10
      return "Entry Point\nThe used IP and/or port is not recognized as valid entry point"
    when 11
      return "Suspended Application\nThe client application has been suspended (illegal usage, ...)"
    when 12
      return "Access Token\nInvalid Access Token."
    when 13
      return "Insufficient Scope\nInsufficient scope. The request requires higher privileges than provided by the access token"
    else
      return "Undefined Error!"
    end
  end
  
  def to_s
    return "#{error_code} #{user_error} (#{error})" if user_error
    "#{error}"
  end
end

class JamendoAuthError < JamendoError
  def initialize(error, http_response=nil, user_error=nil)
    super()
  end
end