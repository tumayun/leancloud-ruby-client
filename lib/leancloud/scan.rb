# -*- encoding : utf-8 -*-
module LC
  class Scan
    attr_accessor :where
    attr_accessor :class_name
    attr_accessor :order_by
    attr_accessor :order
    attr_accessor :limit
    attr_reader :cursor

    def initialize(cls_name)
      @class_name = cls_name
      @where = {}
      @order = :ascending
    end

    def run!
      @more = true
      body.delete(:cursor)
      list = []
      while has_more? do
        list.concat move!
      end
      list
    end

    def move!
      LC.client.logger.info{"Parse scan for #{uri} #{body.inspect}"} unless LC.client.quiet
      response = LC.client.request uri, :get, nil, body

      if response.is_a?(Hash) && response.has_key?(Protocol::KEY_RESULTS) && response[Protocol::KEY_RESULTS].is_a?(Array)
        if response['cursor']
          body[:cursor] = response['cursor']
        else
          @more = false
        end
        response[Protocol::KEY_RESULTS].map{|o| LC.parse_json(class_name, o)}
      else
        raise LCError.new("query response not a Hash with #{Protocol::KEY_RESULTS} key: #{response.class} #{response.inspect}")
      end
    end

    def has_more?
      return @more if defined? @more
      @more = true
    end

    private

    def scan_key
      return @scan_key if defined? @scan_key
      return @scan_key = nil unless order_by
      @scan_key = order_by
      @scan_key = "-#{@scan_key}" if order == :descending
      @scan_key
    end

    def body
      return @body if defined? @body
      @body = {}
      @body[:limit] = limit if limit
      @body[:where] = where.to_json if where
      @body[:scan_key] = scan_key if scan_key
      @body
    end

    def uri
      return @uri if defined? @uri
      @uri = Protocol.scan_uri(class_name)
    end
  end
end
