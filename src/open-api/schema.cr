require "json"
require "yaml"

class Open::Api
  class Schema
    include JSON::Serializable
    include YAML::Serializable

    @[JSON::Field(key: "type")]
    @[YAML::Field(key: "type")]
    property schema_type : String
    property format : String? = nil
    property items : SchemaRef? = nil
    property properties : Hash(String, SchemaRef)? = nil
    property required : Array(String)? = nil
    property default : String | Bool | Int32 | Int64 | Nil = nil

    def initialize(@schema_type, @default = nil,
                   @items : SchemaRef? = nil,
                   @properties : Hash(String, SchemaRef)? = nil,
                   @required = nil, @format = nil)
    end
  end
end
