require './lib/jamendo-sdk'

describe JamendoRequests do
  before :each do
    @client_id = '8264n2s'
    @access_token = 'testtoken'
    @parameters = { one: 'one', two: ['one', 3, 'two words'], three: 3, four: 'four  five ', five: nil }
    @jamendo_request = JamendoRequests.new(@client_id)
  end
  
  it 'should have client id defined' do
    @jamendo_request.client_id == @client_id
    @jamendo_request.access_token == @access_token
  end
  
  it 'format parameters should return correct list' do
    @jamendo_request.format_parameters(@parameters).should include('one', 'two', '3')
    @jamendo_request.format_parameters(@parameters).should include('&')
    @jamendo_request.format_parameters(@parameters).should_not include(' ')
    @jamendo_request.format_parameters(@parameters).should include('+')
    @jamendo_request.format_parameters(@parameters).should_not include('++')
  end
    
end

describe JamendoSession do
  before :each do
    @client_id = '22h1ac47'
    @access_plan = 'rw'
    @jamendo_session = JamendoSession.new(@client_id, @access_plan)
  end    
    
  it 'JamendoSession should have client id and access plan defined' do
    @jamendo_session.client_id == @client_id
    @jamendo_session.access_plan == @access_plan   
  end
    
end