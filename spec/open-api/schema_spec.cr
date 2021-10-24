require "../spec_helper"

struct TestStuct1
  include JSON::Serializable
  property id : UUID
  property name : String
  property age : Int32
  property created_at : Time
  property updated_at : Time

  def initialize(@id, @name, @age, @created_at, @updated_at); end
end

class TestClass1
  include JSON::Serializable
  property id : UUID
  property name : String
  property age : Int32
  property created_at : Time
  property updated_at : Time

  def initialize(@id, @name, @age, @created_at, @updated_at); end
end

FROM_TYPE_TESTS = [
  {
    klass: TestStuct1,
    props: {
      "id" => {
        type:   "string",
        format: "uuid",
      },
      "name" => {
        type:   "string",
        format: nil,
      },
      "age" => {
        type:   "integer",
        format: "int32",
      },
      "created_at" => {
        type:   "string",
        format: "date-time",
      },
      "updated_at" => {
        type:   "string",
        format: "date-time",
      },
    },
  },
  {
    klass: TestClass1,
    props: {
      "id" => {
        type:   "string",
        format: "uuid",
      },
      "name" => {
        type:   "string",
        format: nil,
      },
      "age" => {
        type:   "integer",
        format: "int32",
      },
      "created_at" => {
        type:   "string",
        format: "date-time",
      },
      "updated_at" => {
        type:   "string",
        format: "date-time",
      },
    },
  },
]

describe Open::Api::Schema do
  {% for test in TYPE_TESTS %}
    describe {{test[:klass]}} do
      it "#from_type" do
        schema = Open::Api::Schema.from_type({{test[:klass]}})
        schema.schema_type.should eq {{test[:type]}}
        schema.format.should eq {{test[:format]}}
      end
    end
  {% end %}

  {% for test in FROM_TYPE_TESTS %}
    describe {{test[:klass]}} do
      it "#from_type" do
        test_{{test[:klass].resolve.id.underscore.downcase}}
      end
    end
  {% end %}
end

macro finished
{% for test in FROM_TYPE_TESTS %}
  def test_{{test[:klass].resolve.id.underscore.downcase}}
    schema = Open::Api::Schema.from_type({{test[:klass]}})
    schema.should be_a(Open::Api::Schema)
    schema.schema_type.should eq "object"
    schema.properties.should be_a(Hash(String, Open::Api::SchemaRef))
    schema.properties.not_nil!.should_not be_empty

    props = schema.properties.not_nil!
    {% for prop, t in test[:props] %}
      %value = props[{{prop}}]?
      %value.should be_a(Open::Api::Schema)
      %value.as(Open::Api::Schema).schema_type.should eq {{t[:type]}}
      %value.as(Open::Api::Schema).format.should eq {{t[:format]}}
    {% end %}
  end
{% end %}
end
