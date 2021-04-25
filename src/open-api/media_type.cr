require "json"
require "yaml"

class Open::Api
  class MediaType
    include JSON::Serializable
    include YAML::Serializable

    property schema : SchemaRef

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property example : Open::Api::ExampleValue | Open::Api::Ref = nil

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property examples : Hash(String, Open::Api::ExampleValue | Open::Api::Ref)? = nil

    def initialize(@schema : SchemaRef, @example = nil, @examples = nil); end
  end
end
