require 'jamendo'

describe Jamendo::Requests do
  before :each do
    @client_id = '8264n2s'
    @access_token = 'testtoken'
    @parameters = { one: 'one', two: ['one', 3, 'two words'], three: 3, four: 'four  five ', five: nil }
    @jamendo_request = Jamendo::Requests.new(@client_id, @access_token)
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