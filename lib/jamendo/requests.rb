require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'
require 'rexml/document'
require 'jamendo'
require 'jamendo/error'

# Sending requests to Jamendo - keeps last response in self (read-only)
# Access token set to nil because it's not used by most read-only requests
module Jamendo
  class Requests
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
      raise Jamendo::Error.new("Please provide hash!") unless parameters.kind_of?(Hash)
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
        raise Jamendo::Error.new("Jamendo Server Error: #{response} - #{response.body}", response)
      end
    
      case @format
      when :json
        JSON.parse(response.body, symbolize_names: true)
      when :xml
        REXML::Document.new(response.body)
      else
        raise Jamendo::Error.new('You are trying to parse unparsable!')
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
end