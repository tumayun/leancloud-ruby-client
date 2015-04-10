require 'helper'

class TestCloud < AVTestCase
	# functions stored in test/cloud_functions/MyCloudCode
	# see https://parse.com/docs/cloud_code_guide to learn how to use AV Cloud Code
	#
	# AV.Cloud.define('trivial', function(request, response) {
  # 	response.success(request.params);
	# });

	def test_cloud_function_initialize
		assert_not_equal nil, AV::Cloud::Function.new("trivial")
	end

    def test_request_sms
      VCR.use_cassette('test_request_sms', :record => :new_episodes) do
        assert_true AV::Cloud.request_sms :mobilePhoneNumber => "18668012283",:op => "test",:ttl => 5
      end
    end

	def test_cloud_function
		omit("this should automate the parse deploy command by committing that binary to the repo")

		VCR.use_cassette('test_cloud_function', :record => :new_episodes) do
			function = AV::Cloud::Function.new("trivial")
			params = {"foo" => "bar"}
			resp = function.call(params)
			assert_equal resp, params
		end
	end
end
