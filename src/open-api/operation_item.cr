require "json"
require "yaml"

class Open::Api
  class OperationItem
    include JSON::Serializable
    include YAML::Serializable

    property tags : Array(String) = Array(String).new
    property summary : String

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property description : String? = nil
    property responses : Hash(Int32, Response) = Hash(Int32, Response).new

    @[JSON::Field(key: "operationId")]
    @[YAML::Field(key: "operationId")]
    property operation_id : String? = nil
    property parameters : Array(Parameter | Ref) = Array(Parameter | Ref).new

    def initialize(@summary); end

    def initialize(@summary, @description : String? = nil,
                   @tags : Array(String) = Array(String).new,
                   @responses : Hash(Int32, Response) = Hash(Int32, Response).new); end
  end
end
