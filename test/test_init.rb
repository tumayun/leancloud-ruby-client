require 'helper'

#AV.init :application_id => $PARSE_APPLICATION_ID, :api_key => $PARSE_REST_API_KEY

class TestInit < Test::Unit::TestCase
  def setup
    AV.destroy
  end
  
  def test_no_api_keys_error
    fake = AV::Object.new "shouldNeverExist"
    fake["foo"] = "bar"
    
    begin
      fake.save
    rescue
      error_triggered = true
    end
    
    assert_equal error_triggered, true
    assert_equal fake[AV::Protocol::KEY_OBJECT_ID], nil
  end
end
