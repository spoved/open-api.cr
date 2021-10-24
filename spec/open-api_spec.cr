require "./spec_helper"

describe Open::Api do
  TYPE_TESTS.each do |test|
    describe "#{test[:klass]}" do
      it "#get_open_api_type" do
        Open::Api.get_open_api_type(test[:klass]).should eq test[:type]
        Open::Api.get_open_api_type(test[:klass] | Nil).should eq test[:type]
      end

      it "#get_open_api_format" do
        Open::Api.get_open_api_format(test[:klass]).should eq test[:format]
        Open::Api.get_open_api_format(test[:klass] | Nil).should eq test[:format]
      end
    end
  end
end
