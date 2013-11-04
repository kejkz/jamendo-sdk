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