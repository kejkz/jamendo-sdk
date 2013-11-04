equire_relative '../test_helper'
 
describe Jamendo do
  it "must be defined" do
    JAMENDO::VERSION.wont_be_nil
  end
 
end