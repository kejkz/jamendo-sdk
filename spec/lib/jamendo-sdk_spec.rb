require './lib/jamendo-sdk'

describe JamendoRequests do
  before :each do
    @client_id = '8264n2s'
    @access_token = 'testtoken'
    @parameters = { one: 'one', two: ['one', 3, 'two words'], three: 3, four: 'four  five ', five: nil }
    @jamendo_request = JamendoRequests.new(@client_id, @access_token)
    @validate_parameters = {artist: 'frozen youghurt', id: 1234 }
    @valid = [:artist, :id]
  end
  
  it 'should have client id defined' do
    @jamendo_request.client_id.should eq(@client_id)
    @jamendo_request.access_token.should eq(@access_token)
  end
  
  it 'format parameters should return correct list' do
    @jamendo_request.format_parameters(@parameters).should include('one', 'two', '3')
    @jamendo_request.format_parameters(@parameters).should include('&')
    @jamendo_request.format_parameters(@parameters).should_not include(' ')
    @jamendo_request.format_parameters(@parameters).should include('+')
    @jamendo_request.format_parameters(@parameters).should_not include('++')
  end    
end

describe JamendoError do
  before :each do
    @jamendo_error = JamendoError.new('Testing error responses', nil, "Big mistake", 3)
  end
    
  it 'JamendoError should return error values ' do
    @jamendo_error.error.should include('Testing error responses')
    @jamendo_error.error_code.should eq(3)
    @jamendo_error.user_error.should include("Big mistake")
    @jamendo_error.http_response.should eq(nil)
    # @jamendo_error.to_s.should include("Testing error responses", "Big Mistake")
  end
end

describe JamendoParameters do
  before :all do
    @parameters_hash = { artist: 'frozen youghurt', id: 1234 }
    @parameters_array = [:jim, :jil]
    @jamendo_parameters = JamendoParameters.new(@parameters_hash)
  end
  
  it 'JamendoParameters should include methods sent as hash' do
    @jamendo_parameters.artist.should include(@parameters_hash[:artist])
    @jamendo_parameters.id.should include(@parameters_hash[:id].to_s)
  end
end