require "json"
require "yaml"

class Open::Api
  class Response
    include JSON::Serializable
    include YAML::Serializable

    property description : String? = nil
    property headers : Hash(String, Open::Api::Header) = Hash(String, Open::Api::Header).new
    property content : Hash(String, Open::Api::MediaType) = Hash(String, Open::Api::MediaType).new

    def initialize(@description); end

    def initialize(@description, @content); end
  end
end
