require 'leancloud/protocol'
require 'leancloud/client'
require 'leancloud/error'
require 'leancloud/object'

module LC
  class Installation < LC::Object
    UPDATABLE_FIELDS = {
      badge: 'badge',
      channels: 'channels',
      time_zone: 'timeZone',
      device_token: 'deviceToken',
      channel_uris: 'channelUris',
      app_name: 'appName',
      app_version: 'appVersion',
      parse_version: 'parseVersion',
      app_identifier: 'appIdentifier'
    }

    def initialize(parse_object_id)
      @parse_object_id = parse_object_id
    end

    def self.get(parse_object_id)
      new(parse_object_id).get
    end

    def get
      if response = LC.client.request(uri, :get, nil, nil)
        parse LC.parse_json(nil, response)
      end
    end

    UPDATABLE_FIELDS.each do |method_name, key|
      define_method "#{method_name}=" do |value|
        body[key] = value
      end
    end

    def uri
      Protocol.installation_uri @parse_object_id
    end

    def save
      LC.client.request uri, method, body.to_json, nil
    end

    def rest_api_hash
      self
    end

    def method
      @parse_object_id ? :put : :post
    end

    def body
      return @body if defined? @body
      @body = {}
    end
  end
end
