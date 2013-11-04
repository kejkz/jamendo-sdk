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