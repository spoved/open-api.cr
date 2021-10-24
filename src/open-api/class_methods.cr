require "uri"
require "uuid"

class Open::Api
  module ClassMethods
    def get_open_api_format(type : Class, name : String? = nil) : String?
      case type
      when .>=(UUID)
        "uuid"
      when .>=(Time)
        "date-time"
      when .>=(Int64)
        "int64"
      when .>=(Int32)
        "int32"
      when .>=(Float64)
        "double"
      when .>=(Float32)
        "float"
      when .>=(Bool), .>=(String), .>=(URI)
        nil
      else
        raise "unable determine Open::Api format for #{type} : #{name}"
      end
    end

    def get_open_api_type(type : Class) : String
      case type
      when .>=(String), .>=(URI), .>=(UUID), .>=(Time)
        "string"
      when .<=(Int), .>=(Int64 | Nil), .>=(Int32 | Nil)
        "integer"
      when .<=(Float), .>=(Float64 | Nil), .>=(Float32 | Nil)
        "number"
      when .>=(Bool)
        "boolean"
      else
        raise "unable determine Open::Api type for #{type}"
      end
    end
  end
end
