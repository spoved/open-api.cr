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

  alias RouteMetaDatum = Hash(Symbol, Bool | Hash(Symbol, String) | String | Nil | Hash(String, Open::Api::SchemaRef))

  class_property schema_refs = Hash(String, Hash(String, Open::Api::SchemaRef)).new
  class_property route_meta = Hash(String, Hash(String, RouteMetaDatum)).new

  module ClassMethods
    private def path_definition(oper, data, api_def) : Open::Api::OperationItem
      pdef = Open::Api::OperationItem.new(
        summary: data[:multi] ? "#{oper} #{data[:model]} list" : "#{oper} #{data[:model]}"
      )

      schema = if !data[:schema].nil?
                 Open::Api::Schema.new(
                   schema_type: "object",
                   properties: data[:schema].as(Hash(String, Open::Api::SchemaRef)),
                 )
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
        unless data[:filter].as(Hash(Symbol, String)).empty?
          data[:filter].as(Hash(Symbol, String)).keys.map(&.to_s).each do |name|
            pdef.parameters << Open::Api::Parameter.new(name, "query", Open::Api::Schema.new("string"))
          end
        end

        if data[:multi]
          pdef.responses[200] = Open::Api::Response.new("fetch #{data[:model]} object")
          pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(
            schema: Open::Api::Schema.new(
              schema_type: "object",
              properties: Hash(String, Open::Api::SchemaRef){
                "limit"  => Open::Api::Schema.new("integer"),
                "offset" => Open::Api::Schema.new("integer"),
                "size"   => Open::Api::Schema.new("integer"),
                "total"  => Open::Api::Schema.new("integer"),
                "data"   => Open::Api::Schema.new(
                  schema_type: "array",
                  items: schema,
                ),
              },
            )
          )

          pdef.parameters << Open::Api::Parameter.new("limit", "query", Open::Api::Schema.new("string"))
          pdef.parameters << Open::Api::Parameter.new("offset", "query", Open::Api::Schema.new("string"))
        else
          pdef.responses[200] = Open::Api::Response.new("fetch #{data[:model]} objects")
          pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(schema: schema)
        end
      when "delete"
        pdef.responses[204] = Open::Api::Response.new("Delete #{data[:model]} object")
      when "put"
        pdef.responses[200] = Open::Api::Response.new("Create #{data[:model]} object")
        pdef.responses[200].content["application/json"] = Open::Api::MediaType.new(schema: schema)
      else
        raise "Oper #{oper} not supported"
      end
      pdef
    end

    private def format_name(name : String)
      name.gsub("::", "")
    end

    def build_open_api(title)
      File.open("fulgurite-api.spec.yaml", "w") do |file|
        api_def = Open::Api.new(title)

        schema_refs.each do |name, props|
          api_def.components.schemas[format_name(name)] = Open::Api::Schema.new(
            schema_type: "object",
            properties: props,
          )
        end

        route_meta.each do |path, opers|
          opers.each do |oper, data|
            api_def.paths[path] = Open::Api::PathItem.new unless api_def.paths[path]?
            api_def.paths[path][oper] = path_definition(oper, data, api_def)
          end
        end

        file.puts api_def.to_yaml
      end
    end
  end

  extend ClassMethods
end
