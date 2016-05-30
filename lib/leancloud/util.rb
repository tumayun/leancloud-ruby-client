# -*- encoding : utf-8 -*-

module LC

  # Parse a JSON representation into a fully instantiated
  # class. obj can be either a primitive or a Hash of primitives as parsed
  # by JSON.parse
  # @param class_name [Object]
  # @param obj [Object]
  def LC.parse_json(class_name, obj)
    if obj.nil?
      nil

    # Array
    elsif obj.is_a? Array
      obj.collect { |o| parse_json(class_name, o) }

    # Hash
    elsif obj.is_a? Hash

      # If it's a datatype hash
      if obj.has_key?(Protocol::KEY_TYPE)
        parse_datatype obj
      elsif class_name # otherwise it must be a regular object, so deep parse it avoiding re-JSON.parsing raw Strings
        LC::Object.new class_name, Hash[obj.map{|k,v| [k, parse_json(nil, v)]}]
      else # plain old hash
        obj
      end

    # primitive
    else
      obj
    end
  end

  def LC.parse_datatype(obj)
    type = obj[Protocol::KEY_TYPE]

    case type
      when Protocol::TYPE_POINTER
        if obj[Protocol::KEY_CREATED_AT]
          LC::Object.new obj[Protocol::KEY_CLASS_NAME], Hash[obj.map{|k,v| [k, parse_json(nil, v)]}]
        else
          LC::Pointer.new obj
        end
      when Protocol::TYPE_BYTES
        LC::Bytes.new obj
      when Protocol::TYPE_DATE
        LC::Date.new obj
      when Protocol::TYPE_GEOPOINT
        LC::GeoPoint.new obj
      when Protocol::TYPE_FILE
        LC::File.new obj
      when Protocol::TYPE_OBJECT # used for relation queries, e.g. "?include=post"
        LC::Object.new obj[Protocol::KEY_CLASS_NAME], Hash[obj.map{|k,v| [k, parse_json(nil, v)]}]
    end
  end

  def LC.pointerize_value(obj)
    if obj.kind_of?(LC::Object)
      p = obj.pointer
      raise ArgumentError.new("new object used in context requiring pointer #{obj}") unless p
      p
    elsif obj.is_a?(Array)
      obj.map do |v|
        LC.pointerize_value(v)
      end
    elsif obj.is_a?(Hash)
      Hash[obj.map do |k, v|
        [k, LC.pointerize_value(v)]
      end]
    else
      obj
    end
  end

  def LC.object_pointer_equality?(a, b)
    classes = [LC::Object, LC::Pointer]
    return false unless classes.any? { |c| a.kind_of?(c) } && classes.any? { |c| b.kind_of?(c) }
    return true if a.equal?(b)
    return false if a.new? || b.new?

    a.class_name == b.class_name && a.id == b.id
  end

  def LC.object_pointer_hash(v)
    if v.new?
      v.object_id
    else
      v.class_name.hash ^ v.id.hash
    end
  end
end
