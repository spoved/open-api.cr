require "json"
require "yaml"

class Open::Api
  class RequestBody
    include JSON::Serializable
    include YAML::Serializable

    # A brief description of the request body. This could contain examples of use. CommonMark syntax MAY be used for rich text representation.
    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property description : String? = nil
    # The content of the request body. The key is a media type or media type range and the value describes it. For requests that match multiple keys, only the most specific key is applicable. e.g. text/plain overrides text/*
    property content : Hash(String, Open::Api::MediaType) = Hash(String, Open::Api::MediaType).new
    # Determines if the request body is required in the request. Defaults to false.
    property required : Bool = false
  end

  def initialize(@description); end

  def initialize(@description, @content); end

  def initialize(@description, @content, @required); end
end
