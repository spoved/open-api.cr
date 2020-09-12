require "json"
require "yaml"

class Open::Api
  class Parameter
    include JSON::Serializable
    include YAML::Serializable

    property name : String
    @[JSON::Field(key: "in")]
    @[YAML::Field(key: "in")]
    property parameter_in : String
    property description : String?
    property required : Bool = false
    property deprecated : Bool = false
    property schema : SchemaRef | Nil

    def initialize(@name, @parameter_in, @schema : SchemaRef | Nil = nil); end
  end
end
