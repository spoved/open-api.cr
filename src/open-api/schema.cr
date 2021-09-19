require "json"
require "yaml"

class Open::Api
  class Schema
    include JSON::Serializable
    include YAML::Serializable

    @[JSON::Field(key: "type")]
    @[YAML::Field(key: "type")]
    property schema_type : String
    property format : String? = nil
    property items : Open::Api::SchemaRef? = nil
    property properties : Hash(String, Open::Api::SchemaRef)? = nil
    property required : Array(String)? = nil
    property default : String | Bool | Int32 | Int64 | Nil = nil

    @[JSON::Field(emit_nil: false)]
    @[YAML::Field(emit_nil: false)]
    property example : Open::Api::ExampleValue = nil

    def initialize(
      @schema_type : String,
      @default : String | Bool | Int32 | Int64 | Nil = nil,
      @items : Open::Api::SchemaRef? = nil,
      @properties : Hash(String, Open::Api::SchemaRef)? = nil,
      required : Array(String)? = nil,
      @format : String? = nil,
      @example : Open::Api::ExampleValue = nil
    )
      if !required.nil? && !required.empty?
        @required = required
      end
    end

    macro from_type(type)
      {% model = type.resolve %}
      {% klass = model.union_types.empty? ? model : model.union_types.first %}
      {% if klass <= Int32 || klass <= Int64 || klass <= Float32 || klass <= Float64 || klass <= Nil || klass <= UUID || klass <= Bool || klass <= String %}
      Open::Api::Schema.new(Open::Api.get_open_api_type({{klass}}), Open::Api.get_open_api_type({{klass}}))
      {% elsif model <= Array %}
      Open::Api::Schema.new("array",
        items: Open::Api::Schema.from_type({{klass.type_vars.first}}),
      )
      {% else %}
      Open::Api::Schema.new("object",
        {% if model.instance_vars.size > 0 %}
        properties: Hash(String, Open::Api::SchemaRef){
          {% for var in model.instance_vars %}
          "{{var.name}}" => Open::Api::Schema.from_type({{var.type.union_types.reject(&.==(Nil)).first}}),
          {% end %}
        }
        {% end %}
      )
      {% end %}
    end
  end
end
