require "spec"
require "../src/open-api"

TYPE_TESTS = [
  {
    klass:  Int32,
    type:   "integer",
    format: "int32",
  },
  {
    klass:  Int64,
    type:   "integer",
    format: "int64",
  },

  {
    klass:  Float32,
    type:   "number",
    format: "float",
  },
  {
    klass:  Float64,
    type:   "number",
    format: "double",
  },
  {
    klass:  UUID,
    type:   "string",
    format: "uuid",
  },
  {
    klass:  Time,
    type:   "string",
    format: "date-time",
  },
  {
    klass:  String,
    type:   "string",
    format: nil,
  },
  {
    klass:  URI,
    type:   "string",
    format: nil,
  },
  {
    klass:  Bool,
    type:   "boolean",
    format: nil,
  },
]
