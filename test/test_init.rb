require 'helper'

#LC.init :application_id => $LC_APPLICATION_ID, :api_key => $LC_APPLICATION_KEY

class TestInit < Test::Unit::TestCase
  def setup
    LC.destroy
  end
  
  def test_no_api_keys_error
    fake = LC::Object.new "shouldNeverExist"
    fake["foo"] = "bar"
    
    begin
      fake.save
    rescue
      error_triggered = true
    end
    
    assert_equal error_triggered, true
    assert_equal fake[LC::Protocol::KEY_OBJECT_ID], nil
  end
end
