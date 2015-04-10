require 'helper'

class TestInitFromCloudCode < Test::Unit::TestCase
	def test_init
		client = AV.init_from_cloud_code("test/config/global.json")
		assert_equal AV::Client, client.class
	end
end
