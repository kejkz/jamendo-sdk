require 'jamendo/parameters'

describe Jamendo::Parameters do
  before :all do
    @parameters_hash = { artist: 'frozen youghurt', id: 1234 }
    @parameters_array = [:jim, :jil]
    @jamendo_parameters = Jamendo::Parameters.new(@parameters_hash)
  end
  
  it 'JamendoParameters should include methods sent as hash' do
    @jamendo_parameters.artist.should include(@parameters_hash[:artist])
    @jamendo_parameters.id.should include(@parameters_hash[:id].to_s)
  end
  
  it 'Jamendo::Parameters should add methods as called' do
    @jamendo_parameters.title
    # @jamendo_parameters.should respond_to(:title)
    @jamendo_parameters.duration = 20
    @jamendo_parameters.should respond_to(:duration)
    @jamendo_parameters.duration.should eq 20
  end
  
  it 'Jamendo::Parameters should return hash of values when to_hash is called' do
    @jamendo_parameters.to_hash.should be_kind_of(Hash)
  end
  
end