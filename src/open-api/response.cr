require "json"
require "yaml"

class Open::Api
  class Response
    include JSON::Serializable
    include YAML::Serializable

    property description : String
    property headers : Hash(String, Open::Api::Header) = Hash(String, Open::Api::Header).new
    property content : Hash(String, Open::Api::MediaType) = Hash(String, Open::Api::MediaType).new

    def initialize(@description); end
  end
end
