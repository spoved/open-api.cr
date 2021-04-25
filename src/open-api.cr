require "json"
require "yaml"
require "./open-api/*"

class Open::Api
  include JSON::Serializable
  include YAML::Serializable

  property openapi : String = "3.0.0"
  property info : Open::Api::Info
  property servers : Array(Open::Api::Server) = Array(Open::Api::Server).new
  property paths : Open::Api::Paths = Open::Api::Paths.new
  property components : Open::Api::Components = Open::Api::Components.new

  def initialize(@info : Open::Api::Info)
  end

  def initialize(title : String)
    @info = Open::Api::Info.new(title)
  end

  alias SchemaRef = Schema | Ref
  alias Paths = Hash(String, PathItem)
  alias Wrapper = NamedTuple(method: Proc(Open::Api::Schema), key: String)
  alias RouteMetaDatum = Hash(Symbol, Bool | Hash(Symbol, String) | String | Nil | Open::Api::Schema | Wrapper)

  class_property schema_refs = Hash(String, Open::Api::Schema).new
  class_property route_meta = Hash(String, Hash(String, RouteMetaDatum)).new

  module ClassMethods
    private def path_definition(oper, data, api_def) : Open::Api::OperationItem
      pdef = Open::Api::OperationItem.new(
        summary: data[:multi] ? "#{oper} #{data[:model]} list" : "#{oper} #{data[:model]}"
      )
      pdef.parameters << Open::Api::Parameter.new("id", "path", Open::Api::Schema.new("string"), required: true) if data[:path] =~ /\{id\}/

      schema = if !data[:schema].nil?
                 data[:schema].as(Open::Api::Schema)
               elsif api_def.components.schemas[format_name(data[:model].as(String))]?
                 Open::Api::Ref.new("#/components/schemas/#{format_name(data[:model].as(String))}")
               else
                 Open::Api::Schema.new(
                   schema_type: "object",
                   properties: Hash(String, Open::Api::SchemaRef).new,
                 )
               end

      case oper
      when "get"
        if data[:multi]
          pdef.responses[200] = Open::Api::Response.new("fetch #{data[:model]} object")
          wrapper = data[:wrapper].as(Wrapper)

          refname = "#{format_name(data[:model].as(String))}List"
          s = wrapper[:method].call
          s.properties.not_nil![wrapper[:key]] = Open::Api::Schema.new(
            "array", items: schema
          )
          Open::Api.schema_refs[refname] = s

          pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(
            schema: Open::Api::Ref.new("#/components/schemas/#{refname}")
          )

          pdef.parameters << Open::Api::Parameter.new("limit", "query", Open::Api::Schema.new("number", example: 10))
          pdef.parameters << Open::Api::Parameter.new("offset", "query", Open::Api::Schema.new("number", example: 0))
          pdef.parameters << Open::Api::Parameter.new("order_by", "query", Open::Api::Schema.new("string"))
        else
          pdef.responses[200] = Open::Api::Response.new("fetch #{data[:model]} objects")
          pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(schema: schema)
        end

        unless data[:filter].as(Hash(Symbol, String)).empty?
          data[:filter].as(Hash(Symbol, String)).keys.map(&.to_s).each do |name|
            pdef.parameters << Open::Api::Parameter.new(name, "query", Open::Api::Schema.new("string"))
          end
        end
      when "delete"
        pdef.responses[204] = Open::Api::Response.new("Delete #{data[:model]} object")
      when "put"
        pdef.responses[200] = Open::Api::Response.new("Create #{data[:model]} object")
        pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(schema: schema)
      when "options"
        pdef.responses[200] = Open::Api::Response.new("options")
        pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(schema: schema)
      else
        raise "Oper #{oper} not supported"
      end
      pdef
    end

    private def format_name(name : String)
      name.gsub("::", "")
    end

    def build_open_api(title) : Open::Api
      api_def = Open::Api.new(title)

      # Populate components
      schema_refs.each do |name, schema|
        api_def.components.schemas[format_name(name)] = schema
      end

      route_meta.each do |path, opers|
        opers.each do |oper, data|
          api_def.paths[path] = Open::Api::PathItem.new unless api_def.paths[path]?
          api_def.paths[path][oper] = path_definition(oper, data, api_def)
        end
      end

      # Populate components with any missing ones

      schema_refs.each do |name, schema|
        unless api_def.components.schemas[format_name(name)]?
          api_def.components.schemas[format_name(name)] = schema
        end
      end

      api_def
    end
  end

  extend ClassMethods
end
