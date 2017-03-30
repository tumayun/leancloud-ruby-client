require 'helper'

class TestDatatypes < Test::Unit::TestCase
  def test_pointer
    data = {
      LC::Protocol::KEY_CLASS_NAME => "DatatypeTestClass",
      LC::Protocol::KEY_OBJECT_ID => "12345abcd"
    }
    p = LC::Pointer.new data

    assert_equal p.to_json, "{\"__type\":\"Pointer\",\"#{LC::Protocol::KEY_CLASS_NAME}\":\"DatatypeTestClass\",\"#{LC::Protocol::KEY_OBJECT_ID}\":\"12345abcd\"}"
  end

  def test_pointer_make
    p = LC::Pointer.make("SomeClass", "someId")
    assert_equal "SomeClass", p.class_name
    assert_equal "someId", p.id
  end

  def test_date
    date_time = Time.at(0).to_datetime
    parse_date = LC::Date.new(date_time)

    assert_equal date_time, parse_date.value
    assert_equal "1970-01-01T00:00:00.000Z", JSON.parse(parse_date.to_json)["iso"]
    assert_equal 0, parse_date <=> parse_date
    assert_equal 0, LC::Date.new(date_time) <=> LC::Date.new(date_time)

    post = LC::Object.new("Post")
    post["time"] = parse_date
    post.save
    q = LC.get("Post", post.id)

    # time zone from parse is utc so string formats don't compare equal,
    # also floating points vary a bit so only equality after rounding to millis is guaranteed
    assert_equal parse_date.to_time.utc.to_datetime.iso8601(3), q["time"].to_time.utc.to_datetime.iso8601(3)
  end

  def test_date_with_bad_data
    assert_raise do
      LC::Date.new(2014)
    end
    assert_raise do
      LC::Date.new(nil)
    end
  end

  def test_date_with_time
    time = Time.parse("01/01/2012 23:59:59")
    assert_equal time, LC::Date.new(time).to_time
  end

  def test_bytes
    data = {
      "base64" => Base64.encode64("testing bytes!")
    }
    byte = LC::Bytes.new data

    assert_equal byte.value, "testing bytes!"
    assert_equal JSON.parse(byte.to_json)[LC::Protocol::KEY_TYPE], LC::Protocol::TYPE_BYTES
    assert_equal JSON.parse(byte.to_json)["base64"], Base64.encode64("testing bytes!")
  end

  def test_increment
    amount = 5
    increment = LC::Increment.new amount

    assert_equal increment.to_json, "{\"__op\":\"Increment\",\"amount\":#{amount}}"
  end

  def test_geopoint
    # '{"location": {"__type":"GeoPoint", "latitude":40.0, "longitude":-30.0}}'
    data = {
      "longitude" => 40.0,
      "latitude" => -30.0
    }
    gp = LC::GeoPoint.new data

    assert_equal JSON.parse(gp.to_json)["longitude"], data["longitude"]
    assert_equal JSON.parse(gp.to_json)["latitude"], data["latitude"]
    assert_equal JSON.parse(gp.to_json)[LC::Protocol::KEY_TYPE], LC::Protocol::TYPE_GEOPOINT

    post = LC::Object.new("Post")
    post["location"] = gp
    post.save
    q = LC.get("Post", post.id)
    assert_equal gp, q["location"]
  end


  # deprecating -  see test_file.rb for new implementation
  # ----------------------------
  #def test_file
  #  data = {"name" => "test/parsers.png"}
  #  file = LC::File.new(data)
    # assert_equal JSON.parse(file.to_json)["name"], data["name"]
    # assert_equal JSON.parse(file.to_json)[LC::Protocol::KEY_TYPE], LC::Protocol::TYPE_FILE

  #  post = LC::Object.new("Post")
  #  post["avatar"] = file
  #  post.save
  #  q = LC.get("Post", post.id)
  #  assert_equal file.parse_filename, q["avatar"].parse_filename
  #end
end
