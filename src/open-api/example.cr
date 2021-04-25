class Open::Api
  alias ExampleValue = String | Bool | Int32 | Int64 | Float32 | Float64 | Hash(String, Open::Api::ExampleValue) | Array(Open::Api::ExampleValue) | Nil
end
