require "json"
require "yaml"

class Open::Api
  class Server
    include JSON::Serializable
    include YAML::Serializable

    property url : String? = nil
    property description : String? = nil

    def initialize(@url, @description = nil)
    end
  end
end
