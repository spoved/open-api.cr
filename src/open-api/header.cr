require "json"
require "yaml"

class Open::Api
  class Header
    include JSON::Serializable
    include YAML::Serializable

    property description : String? = nil
    property required : Bool = false
    property deprecated : Bool = false
    property schema : (SchemaRef)? = nil

    def initialize; end
  end
end
