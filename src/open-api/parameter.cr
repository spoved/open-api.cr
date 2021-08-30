require "json"
require "yaml"

class Open::Api
  # https://swagger.io/specification/#parameter-object
  class Parameter
    include JSON::Serializable
    include YAML::Serializable

    property name : String
    @[JSON::Field(key: "in")]
    @[YAML::Field(key: "in")]
    property parameter_in : String
    property description : String? = nil
    property required : Bool = false
    property deprecated : Bool = false
    property schema : Open::Api::SchemaRef | Nil = nil

    property example : Open::Api::ExampleValue = nil
    property examples : Hash(String, Open::Api::ExampleValue) = Hash(String, Open::Api::ExampleValue).new

    def initialize(@name, @parameter_in, @schema : SchemaRef | Nil = nil, @required : Bool = false,
                   @deprecated : Bool = false, @example : Open::Api::ExampleValue = nil,
                   @examples : Hash(String, Open::Api::ExampleValue) = Hash(String, Open::Api::ExampleValue).new); end

    def self.new(name, type, location = "query", description : String = "", required : Bool = false,
                 default_value : String | Int32 | Int64 | Float64 | Bool | Nil = nil,
                 example : Open::Api::ExampleValue = nil) : Open::Api::Parameter
      schema = Open::Api::Schema.new(
        Open::Api.get_open_api_type(type),
        example: example,
      )
      schema.default = default_value if default_value
      schema.format = Open::Api.get_open_api_format(type, name)

      Open::Api::Parameter.new(
        name,
        parameter_in: location,
        required: required,
        schema: schema
      ).tap do |param|
        param.description = description
      end
    end
  end
end
