module AV
  class Application
    def self.config
      AV.client.request(AV::Protocol.config_uri)['params']
    end
  end
end
