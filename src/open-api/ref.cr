require "json"
require "yaml"

class Open::Api
  class Ref
    include JSON::Serializable
    include YAML::Serializable

    @[JSON::Field(key: "$ref")]
    @[YAML::Field(key: "$ref")]
    property ref : String

    def initialize(@ref); end
  end
end
