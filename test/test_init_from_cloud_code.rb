require 'helper'

class TestInitFromCloudCode < Test::Unit::TestCase
	def test_init
		client = LC.init_from_cloud_code("test/config/global.json")
		assert_equal LC::Client, client.class
	end
end
