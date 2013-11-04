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