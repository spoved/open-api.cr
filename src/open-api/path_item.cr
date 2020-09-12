require "json"
require "yaml"

class Open::Api
  class PathItem
    include JSON::Serializable
    include YAML::Serializable

    property get : OperationItem? = nil
    property put : OperationItem? = nil
    property post : OperationItem? = nil
    property delete : OperationItem? = nil
    property options : OperationItem? = nil
    property head : OperationItem? = nil
    property patch : OperationItem? = nil
    property trace : OperationItem? = nil

    def initialize; end

    def []?(oper : String | Open::Api::Operation) : Bool
      !self[oper].nil?
    end

    def [](oper : String | Open::Api::Operation) : OperationItem?
      case oper
      when "get", Operation::Get
        self.get
      when "put", Operation::Put
        self.put
      when "post", Operation::Post
        self.post
      when "delete", Operation::Delete
        self.delete
      when "options", Operation::Options
        self.options
      when "head", Operation::Head
        self.head
      when "patch", Operation::Patch
        self.patch
      when "trace", Operation::Trace
        self.trace
      else
        nil
      end
    end

    def []=(oper : String | Open::Api::Operation, value : OperationItem)
      case oper
      when "get", Operation::Get
        self.get = value
      when "put", Operation::Put
        self.put = value
      when "post", Operation::Post
        self.post = value
      when "delete", Operation::Delete
        self.delete = value
      when "options", Operation::Options
        self.options = value
      when "head", Operation::Head
        self.head = value
      when "patch", Operation::Patch
        self.patch = value
      when "trace", Operation::Trace
        self.trace = value
      end
    end
  end
end
