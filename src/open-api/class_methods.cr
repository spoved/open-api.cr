require "uri"
require "uuid"

class Open::Api
  module ClassMethods
    def get_open_api_format(type, name : String? = nil) : String?
      case type
      when (UUID | Nil).class, UUID.class
        "uuid"
      when (String | Nil).class, String.class, URI.class
        "string"
      when (Int64 | Nil).class, Int64.class
        "int64"
      when (Int32 | Nil).class, Int32.class
        "int32"
      when (Float64 | Nil).class, Float64.class
        "double"
      when (Float32 | Nil).class, Float32.class
        "float"
      when (Bool | Nil).class, Bool.class
        nil
      else
        raise "unable determine Open::Api format for #{type} : #{name}"
      end
    end

    def get_open_api_type(type) : String
      case type
      when (String | Nil).class, (UUID | Nil).class, String.class, UUID.class, URI.class
        "string"
      when (Int64 | Nil).class, (Int32 | Nil).class, Int64.class, Int32.class
        "integer"
      when (Float64 | Nil).class, (Float32 | Nil).class, Float64.class, Float32.class
        "number"
      when (Bool | Nil).class, Bool.class
        "boolean"
      else
        raise "unable determine Open::Api type for #{type}"
      end
    end
  end
end
