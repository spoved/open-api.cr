require "json"
require "yaml"

class Open::Api
  enum Operation
    Get
    Put
    Post
    Delete
    Options
    Head
    Patch
    Trace
  end
end
