require 'spec_helper'

describe "initialize test" do
  it "verify the Dummy app gets loaded" do
    Rails.application.kind_of?( Dummy::Application ).should == true
  end

  it "verify the VitalSigns Module gets defined" do
    defined?( VitalSigns ).should == "constant"
  end

end
