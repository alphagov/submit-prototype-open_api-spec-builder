require "rspec"

require_relative "../lib/swaggerise"

describe "It runs" do

  it "generates an Open API spec from a simple form" do
    input = File.read("examples/simple.json")
    expected = JSON.parse(File.read("examples/simple.api.json"))
    actual = Swaggerise.new(input).run

    expect(actual).to eq(expected)
  end
end

describe Swaggerise do
  context "#inputtype_text" do
    it "generates a JSON snipper" do
      value = {
        "inputtype": "text"
      }

      expected = { "type" => "string" }

      swaggerise = Swaggerise.new
      result = Jbuilder.new do |json|
        swaggerise.inputtype_text(json, value)
      end.attributes!

      expect(result).to eq(expected)
    end
  end

  context "#inputtype_radio" do
    it "generates a JSON snipper" do
      value = <<-JSON
        {
          "adult": {
            "field": "adult",
            "inputtype": "radio",
            "items": [
              { "label": "Yes", "value": "yes" },
              { "label": "No", "value": "no" }
            ]
          }
        }
      JSON

      expected = {
        "type" => "string",
        "enum" => [ "yes", "no" ]
      }

      swaggerise = Swaggerise.new(value)
      result = Jbuilder.new do |json|
        swaggerise.inputtype_radio(json, swaggerise.form.adult)
      end.attributes!

      expect(result).to eq(expected)
    end
  end
end
