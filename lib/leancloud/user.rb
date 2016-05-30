# -*- encoding : utf-8 -*-
require 'leancloud/protocol'
require 'leancloud/client'
require 'leancloud/error'
require 'leancloud/object'

module LC
  class User < LC::Object

    def self.become(token)
      response = LC.client._request(uri: LC::Protocol::USER_CURRENT_URI, session_token: token)
      LC.client.session_token = response[LC::Protocol::KEY_USER_SESSION_TOKEN]
      new(response)
    end

    def self.authenticate(username, password)
      body = {
        "username" => username,
        "password" => password
      }

      response = LC.client.request(LC::Protocol::USER_LOGIN_URI, :get, nil, body)
      LC.client.session_token = response[LC::Protocol::KEY_USER_SESSION_TOKEN]

      new(response)
    end

    def self.reset_password(email)
      body = {"email" => email}
      LC.client.post(LC::Protocol::PASSWORD_RESET_URI, body.to_json)
    end

    def initialize(data = nil)
      data["username"] = data[:username] if data[:username]
      data["password"] = data[:password] if data[:password]
      super(LC::Protocol::CLASS_USER, data)
    end

    def uri
      Protocol.user_uri @parse_object_id
    end

  end
end
