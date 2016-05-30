module LC
  class Application
    def self.config
      LC.client.request(LC::Protocol.config_uri)['params']
    end
  end
end
