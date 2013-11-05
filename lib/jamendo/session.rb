require 'rubygems'
require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'
require 'jamendo'

module Jamendo
  # Define Jamendo session for authorising read/write client access
  class Session
    attr_reader   :access_plan, :client_id, :access_plan, :client_secret
    # What you need to do when creating Jamendo session is to send your
    # client id, client secret obtained from Jamendo as mush 
    def initialize(client_id, client_secret, redirect_uri='', state='')
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = "http://localhost"
      @access_plan = :read_only
      @state = state
      @scope = 'music' # hard-coded due to Jamendo API documentation
      # response = authorize(@client_id, redirect_uri, state, @scope)
      # grant()    
    end
    # Request to Jamendo is expressed like:  
    # http[s]://api.jamendo.com/<version>/<entity>/<subentity>/?<api_parameter>=<value>
    def self.do_http_authenticated(uri, auth_token, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
    end
  
    def do_post(url, headers=nil, body=nil)
      URI.parse(url)
    end
  
    def do_put(url, headers=nil, body=nil)
      URI.parse(url)
    end
  
    def set_access_plan(access_plan)
      @access_plan = access_plan
    end
  
    def set_client_id(client_id)
      @client_id = client_id
    end
  
    ############################################################################
    # Returns authorisation response once it was completed
    ############################################################################
    def get_auth_response
      puts @auth_response.inspect
    end
  
    ############################################################################
    # Authorizes Jamendo application https://api.jamendo.com/v3.0/oauth/authorize
    ############################################################################
    def authorize()
      # additional_params = "&state=#{@state}"
      uri = URI.parse("https://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}/oauth/authorize?client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=TESTSTATE")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      begin
        auth_response = http.request(request)
      rescue => e
        e.inspect
      end
      @auth_response = auth_response.header['Location']    
    end
  
    #############################################################################
    # Grant application access https://api.jamendo.com/v3.0/oauth/grant
    # returns authenticate json object and stores information in Oauth object
    #############################################################################
    def grant(authorize_code)
      uri = URI.parse("https://#{Jamendo::API_SERVER}/v#{Jamendo::API_VERSION}/oauth/grant?client_id=#{@client_id}&client_secret=#{@client_secret}&grant_type=authorization_code&code=#{@auth_code}&redirect_uri=#{@redirect_uri}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      begin
        response = http.request(request)
      rescue => e
        e.inspect
      end
      return JSON.parse(response.body, symbolize_names: true)
    end
  
    #############################################################################
    # Opens authentication url (should work in every OS) in default browser
    ############################################################################# 
    def open_auth_url()
      # link = "Insert desired link location here"
      if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
        system "start #{@auth_response}"
      elsif RbConfig::CONFIG['host_os'] =~ /darwin/
        system('open', @auth_response)
      elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
        system "xdg-open #{@auth_response}"
      end    
    end
  end
end