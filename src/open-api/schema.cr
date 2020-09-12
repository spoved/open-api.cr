require "json"
require "yaml"

class Open::Api
  class Schema
    include JSON::Serializable
    include YAML::Serializable

    @[JSON::Field(key: "type")]
    @[YAML::Field(key: "type")]
    property schema_type : String
    property items : SchemaRef? = nil
    property properties : Hash(String, SchemaRef) = Hash(String, SchemaRef).new

    def initialize(@schema_type, @items : SchemaRef? = nil,
                   @properties : Hash(String, SchemaRef) = Hash(String, SchemaRef).new)
    end
  end
end
