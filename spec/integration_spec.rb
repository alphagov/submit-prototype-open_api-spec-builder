require "rspec"

require_relative "../lib/open_api_spec_builder"

describe "It runs" do

  it "generates an Open API spec from a simple form" do
    input = File.read("examples/simple.json")
    expected = JSON.parse(File.read("examples/simple.api.json"))
    actual = OpenAPISpecBuiler.new(input).run

    expect(actual).to eq(expected)
  end

  it "generates an Open API spec from a real form" do
    input = File.read("examples/apply-for-a-medal.json")
    expected = JSON.parse(File.read("examples/apply-for-a-medal.api.json"))
    actual = OpenAPISpecBuiler.new(input).run

    expect(actual).to eq(expected)
  end
end

describe OpenAPISpecBuiler do
  context "#inputtype_text" do
    it "generates a JSON snipper" do
      value = {
        "inputtype": "text"
      }

      expected = { "type" => "string" }

      open_api = OpenAPISpecBuiler.new
      result = Jbuilder.new do |json|
        open_api.inputtype_text(json, value)
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

      open_api = OpenAPISpecBuiler.new(value)
      result = Jbuilder.new do |json|
        open_api.inputtype_radio(json, open_api.form.adult)
      end.attributes!

      expect(result).to eq(expected)
    end
  end
end
