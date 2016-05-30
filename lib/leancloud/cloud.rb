# -*- encoding : utf-8 -*-
module LC
  module Cloud

    class Function
      attr_accessor :function_name

      def initialize(function_name)
        @function_name = function_name
      end

      def uri
        Protocol.cloud_function_uri(@function_name)
      end

      def call(params={})
        response = LC.client.post(self.uri, params.to_json)
        result = response["result"]
        result
      end
    end

    def self.request_sms(params)
      LC.client.post("/#{Protocol::VERSION}/requestSmsCode", params.to_json)
    end

    def self.verify_sms_code(phone, code)
      params = { mobilePhoneNumber: phone}
      LC.client.post("/#{Protocol::VERSION}/verifySmsCode/#{code}", params.to_json)
    end
  end
end
