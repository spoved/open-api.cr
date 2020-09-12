require "json"
require "yaml"

class Open::Api
  class Components
    include JSON::Serializable
    include YAML::Serializable

    property schemas : Hash(String, Open::Api::Schema) = Hash(String, Open::Api::Schema).new
    property responses : Hash(String, Open::Api::Response) = Hash(String, Open::Api::Response).new
    property parameters : Hash(String, Open::Api::Parameter) = Hash(String, Open::Api::Parameter).new
    # property  examples : Hash(String, Open::Api::Example) = Hash(String, Open::Api::Example).new
    # @[JSON::Field(key: "requestBodies")]
    # @[YAML::Field(key: "requestBodies")]
    # property  request_bodies : Hash(String, Open::Api::RequestBody) = Hash(String, Open::Api::RequestBody).new
    property headers : Hash(String, Open::Api::Header) = Hash(String, Open::Api::Header).new

    # @[JSON::Field(key: " securitySchemes")]
    # @[YAML::Field(key: " securitySchemes")]
    # property   security_schemes : Hash(String, Open::Api::SecurityScheme) = Hash(String, Open::Api::SecurityScheme).new
    # property links : Hash(String, Open::Api::Link) = Hash(String, Open::Api::Link).new
    # property callbacks : Hash(String, Open::Api::Callback) = Hash(String, Open::Api::Callback).new

    def initialize; end
  end
end
