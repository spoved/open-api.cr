require "json"
require "yaml"

class Open::Api
  class Response
    include JSON::Serializable
    include YAML::Serializable

    property description : String? = nil
    property headers : Hash(String, Open::Api::Header) = Hash(String, Open::Api::Header).new

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property content : Hash(String, Open::Api::MediaType)? = nil

    def initialize(@description); end

    def initialize(@description, @content); end
  end
end
