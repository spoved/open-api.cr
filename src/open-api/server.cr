require "json"
require "yaml"

class Open::Api
  class Server
    include JSON::Serializable
    include YAML::Serializable

    property url : String?
    property description : String?
  end
end
