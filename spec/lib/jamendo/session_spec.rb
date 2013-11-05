require 'jamendo/session'

# Generic Jamendo session test
describe Jamendo::Session do
  before :each do
    @client_id = '22h1ac47'
    @access_plan = :read_only
    @client_secret = 'd1rdtysqrt'
    @jamendo_session = Jamendo::Session.new(@client_id, @client_secret)    
    
  it 'JamendoSession should have client id and access plan defined when initialized' do
    expect(@jamendo_session.client_id).to eq(@client_id)
    expect(@jamendo_session.client_secret).to eq(@client_secret)
    expect(@jamendo_session.access_plan).to eq(@access_plan)
  end
  
  it 'JamendoSession should send authorize request to jamendo API'
    expect(@jamendo_session.auth_response[:code]).to eq('200')
  end 

end