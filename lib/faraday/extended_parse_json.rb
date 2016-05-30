# -*- encoding : utf-8 -*-
module Faraday

  class ExtendedParseJson < FaradayMiddleware::ParseJson

    def process_response(env)
      env[:raw_body] = env[:body] if preserve_raw?(env)


      if env[:status] >= 400
        data = parse(env[:body]) || {} rescue {}

        array_codes = [
          LC::Protocol::ERROR_INTERNAL,
          LC::Protocol::ERROR_TIMEOUT,
          LC::Protocol::ERROR_EXCEEDED_BURST_LIMIT
        ]
        error_hash = { "error" => "HTTP Status #{env[:status]} Body #{env[:body]}", "http_status_code" => env[:status] }.merge(data)
        if data['code'] && array_codes.include?(data['code'])
          sleep 60 if data['code'] == LC::Protocol::ERROR_EXCEEDED_BURST_LIMIT
          raise exception(env).new(error_hash.merge(data))
        elsif env[:status] >= 500
          raise exception(env).new(error_hash.merge(data))
        end
        raise LC::LCProtocolError.new(error_hash)
      else
        data = parse(env[:body]) || {}

        env[:body] = data
      end
    end

    def exception env
      # decide to retry or not
      (env[:retries].to_i.zero? ? LC::LCProtocolError : LC::LCProtocolRetry)
    end

  end
end
