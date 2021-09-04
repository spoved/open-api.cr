require "json"
require "yaml"
require "./response"
require "./ref"
require "./request_body"

class Open::Api
  class OperationItem
    include JSON::Serializable
    include YAML::Serializable
    # A list of tags for API documentation control. Tags can be used for logical grouping of operations by resources or any other qualifier.
    property tags : Array(String) = Array(String).new
    # A short summary of what the operation does.
    property summary : String? = nil

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    # A verbose explanation of the operation behavior. CommonMark syntax MAY be used for rich text representation.
    property description : String? = nil

    @[JSON::Field(key: "operationId")]
    @[YAML::Field(key: "operationId")]
    property operation_id : String? = nil

    property parameters : Array(Parameter | Ref) = Array(Parameter | Ref).new

    @[JSON::Field(key: "requestBody", emit_nil: false)]
    @[YAML::Field(key: "requestBody", emit_nil: false)]
    property request_body : Open::Api::RequestBody | Open::Api::Ref? = nil

    alias Responses = Hash(String | Int32, Open::Api::Response | Open::Api::Ref)

    # REQUIRED. The list of possible responses as they are returned from executing this operation.
    property responses : Responses = Responses.new

    # A declaration of which security mechanisms can be used for this operation
    property security : Array(Open::Api::Security::Requirement)? = nil

    def initialize(@summary); end

    def initialize(
      @summary : String? = nil, @operation_id : String? = nil,
      @description : String? = nil,
      @tags : Array(String) = Array(String).new,
      @parameters : Array(Parameter | Ref) = Array(Parameter | Ref).new,
      @request_body : Open::Api::RequestBody | Open::Api::Ref? = nil,
      @responses : Responses = Responses.new,
      security : Array(Open::Api::Security::Requirement)? = nil
    )
      if !security.nil? && !security.empty?
        @security = security
      end
    end
  end
end
