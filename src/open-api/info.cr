require "json"
require "yaml"

class Open::Api
  class Info
    include JSON::Serializable
    include YAML::Serializable

    property title : String
    property description : String? = nil
    @[JSON::Field(key: "termsOfService")]
    @[YAML::Field(key: "termsOfService")]
    property terms_of_service : String? = nil
    property contact : Contact = Open::Api::Contact.new
    property license : License = Open::Api::License.new
    property version : String = "3.0.0"

    def initialize(@title); end
  end

  class Contact
    include JSON::Serializable
    include YAML::Serializable

    property name : String? = nil
    property url : String? = nil
    property email : String? = nil

    def initialize; end
  end

  class License
    include JSON::Serializable
    include YAML::Serializable

    property name : String = "Apache 2.0"
    property url : String? = nil

    def initialize; end
  end
end
