###############################################################################
# Keeps OAuth Token during session
###############################################################################
class OAuthToken
  def initialize(key, secret)
    @key = key
    @secret = secret
  end

  def key
    @key
  end

  def secret
    @secret
  end
end
