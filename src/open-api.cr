require "json"
require "yaml"
require "./open-api/*"

class Open::Api
  include JSON::Serializable
  include YAML::Serializable

  property openapi : String = "3.0.0"
  property info : Open::Api::Info = Open::Api::Info.new("Open Api Server")
  property servers : Array(Open::Api::Server) = Array(Open::Api::Server).new
  property paths : Open::Api::Paths = Open::Api::Paths.new
  property components : Open::Api::Components = Open::Api::Components.new
  # Apply the security globally to all operations
  property security : Hash(String, Array(String)) = Hash(String, Array(String)).new

  def initialize(@info : Open::Api::Info); end

  def initialize(title : String = "Open Api Server")
    @info = Open::Api::Info.new(title)
  end

  alias SchemaRef = Schema | Ref
  alias Paths = Hash(String, PathItem)
  alias Wrapper = NamedTuple(method: Proc(Open::Api::Schema), key: String)
  alias RouteMetaDatum = Hash(Symbol, Bool | Hash(Symbol, String) | Array(String) | String | Nil | Open::Api::Schema | Wrapper)

  class_property schema_refs : Hash(String, Open::Api::Schema) = Hash(String, Open::Api::Schema).new
  class_property route_meta : Hash(String, Hash(String, RouteMetaDatum)) = Hash(String, Hash(String, RouteMetaDatum)).new

  def add_path(path, op : String | Open::Api::Operation, item : Open::Api::OperationItem)
    self.paths[path] = Open::Api::PathItem.new unless self.paths[path]?
    if op.is_a?(String)
      op = Open::Api::Operation.parse(op)
    end
    if self.paths[path][op]?
      raise "There is already an OperationItem defined at path: #{path} for: #{op}"
    end
    self.paths[path][op] = item
  end

  extend ClassMethods
end
