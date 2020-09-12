require "json"
require "yaml"

class Open::Api
  class MediaType
    include JSON::Serializable
    include YAML::Serializable

    property schema : SchemaRef

    def initialize(@schema : SchemaRef); end
  end
end
