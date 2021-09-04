require "json"
require "yaml"
require "./response"
require "./ref"
require "./request_body"

class Open::Api
  class OperationItem
    include JSON::Serializable
    include YAML::Serializable

    property tags : Array(String) = Array(String).new
    property summary : String

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property description : String? = nil
    alias Responses = Hash(String | Int32, Open::Api::Response | Open::Api::Ref)
    property responses : Responses = Responses.new

    @[JSON::Field(key: "requestBody", emit_nil: false)]
    @[YAML::Field(key: "requestBody", emit_nil: false)]
    property request_body : Open::Api::RequestBody | Open::Api::Ref? = nil

    @[JSON::Field(key: "operationId")]
    @[YAML::Field(key: "operationId")]
    property operation_id : String? = nil
    property parameters : Array(Parameter | Ref) = Array(Parameter | Ref).new

    property security : Hash(String, Array(String)) = Hash(String, Array(String)).new

    def initialize(@summary); end

    def initialize(@summary, @description : String? = nil,
                   @tags : Array(String) = Array(String).new,
                   @responses : Responses = Responses.new); end
  end
end
