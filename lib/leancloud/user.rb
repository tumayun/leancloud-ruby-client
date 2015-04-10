# -*- encoding : utf-8 -*-
require 'leancloud/protocol'
require 'leancloud/client'
require 'leancloud/error'
require 'leancloud/object'

module AV
  class User < AV::Object

    def self.authenticate(username, password)
      body = {
        "username" => username,
        "password" => password
      }

      response = AV.client.request(AV::Protocol::USER_LOGIN_URI, :get, nil, body)
      AV.client.session_token = response[AV::Protocol::KEY_USER_SESSION_TOKEN]

      new(response)
    end

    def self.reset_password(email)
      body = {"email" => email}
      AV.client.post(AV::Protocol::PASSWORD_RESET_URI, body.to_json)
    end

    def initialize(data = nil)
      data["username"] = data[:username] if data[:username]
      data["password"] = data[:password] if data[:password]
      super(AV::Protocol::CLASS_USER, data)
    end

    def uri
      Protocol.user_uri @parse_object_id
    end

  end
end
