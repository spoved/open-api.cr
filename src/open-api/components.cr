require "json"
require "yaml"
require "uri"

class Open::Api
  # Will generate the `register_xxx` and `xxx_ref` methods for each component
  private macro gen_components_methods(comps)
    {% for comp, type in comps.resolve %}
    # Register a `{{type}}` to be used by the OpenAPI spec. Will be stored in `components.{{comp.id}}s`.
    # Use `#{{comp.id}}_ref` to fetch a `Open::Api::Ref` to a {{comp.id}} definition.
    def register_{{comp.id}}(name : String, obj : {{type}})
      name = URI.encode_www_form(name)
      if self.components.{{comp.id}}s[name]?
        raise "There is already an {{type}} defined with name: #{name}"
      end
      self.components.{{comp.id}}s[name] = obj
    end

    # Retrieves a `Open::Api::Ref` by name if it is registered
    def {{comp.id}}_ref(name : String) : Open::Api::Ref
      unless self.components.{{comp.id}}s[name]?
        raise "There is no Schema defined with name: #{name}"
      end
      Open::Api::Ref.new("#/components/{{comp.id}}s/#{URI.encode_www_form(name)}")
    end

    # Returns `true` if a `{{type}}` is registered under the given name. Returns `false` otherwise.
    def has_{{comp.id}}_ref?(name : String) : Bool?
      name = URI.encode_www_form(name)
      self.components.{{comp.id}}s[name]?
    end
    {% end %}
  end

  COMP_TYPES = {
    schema:    Open::Api::Schema,
    response:  Open::Api::Response,
    parameter: Open::Api::Parameter,
    header:    Open::Api::Header,
  }
  gen_components_methods(COMP_TYPES)

  class Components
    include JSON::Serializable
    include YAML::Serializable

    macro gen_components_attributes(comps)
      {% for comp, type in comps.resolve %}
      property {{comp.id}}s : Hash(String, {{type}} | Open::Api::Ref) = Hash(String, {{type}} | Open::Api::Ref).new
      {% end %}
    end

    gen_components_attributes COMP_TYPES

    # property examples : Hash(String, Open::Api::Example) = Hash(String, Open::Api::Example).new

    # @[JSON::Field(key: "requestBodies")]
    # @[YAML::Field(key: "requestBodies")]
    # property  request_bodies : Hash(String, Open::Api::RequestBody) = Hash(String, Open::Api::RequestBody).new

    # @[JSON::Field(key: " securitySchemes")]
    # @[YAML::Field(key: " securitySchemes")]
    # property   security_schemes : Hash(String, Open::Api::SecurityScheme) = Hash(String, Open::Api::SecurityScheme).new
    # property links : Hash(String, Open::Api::Link) = Hash(String, Open::Api::Link).new
    # property callbacks : Hash(String, Open::Api::Callback) = Hash(String, Open::Api::Callback).new

    def initialize; end
  end
end
