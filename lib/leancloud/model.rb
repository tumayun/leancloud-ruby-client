# -*- encoding : utf-8 -*-
module AV
  class Model < AV::Object

    def initialize(data=nil)
      super(self.class.to_s,data)
    end

    def self.find(object_id)
      self.new AV::Query.new(self.to_s).eq('objectId',object_id).first
    end

  end
end
