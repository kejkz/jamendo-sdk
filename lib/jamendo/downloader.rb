require 'net/http'

# Class that will define part-downloader
# Send url from Jamendo :audio tag response
# http://storage-new.newjamendo.com/download/track/145317/mp31/
module Jamendo
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
end