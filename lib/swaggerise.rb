require "jbuilder"
require "json"

class Swaggerise

  attr :form

  def initialize(form_json = nil)
    @form = JSON.parse(form_json, object_class: OpenStruct) if form_json
  end

  def to_builder
    Jbuilder.new do |json|
      json.openapi "3.0.0"
      json.info do
        json.title form.heading
        json.description "An API for '#{form.description}'"
        json.version "0.0.1"
      end

      json.servers do
        json.child! do 
          json.url "https://api.#{form.name}.service.gov.uk/alpha"
          json.description "Alpha url"
        end
        json.child! do 
          json.url "https://staging.api.#{form["name"]}.service.gov.uk/alpha"
          json.description "Optional server description, e.g. Internal staging server for testing"
        end
      end

      json.paths do
        json.method_missing("/submission") do
          json.post do
            json.summary "Submit form data"
            json.requestBody do
              json.description "Optional description in *Markdown*"
              json.required true 
              json.content do
                json.method_missing("application/json") do
                  json.schema do
                    json.method_missing("$ref", "#/components/schemas/Submission")
                  end
                end
              end
            end

            json.responses do
              json.method_missing("201") do
                json.description "Created"
                json.content do
                  json.method_missing("application/json") do
                    json.schema do
                      json.method_missing("$ref", "#/components/schemas/Created")
                    end
                  end
                end
              end
            end
          end
        end
      end

      json.components do
        json.schemas do
          json.Submission do
            json.type "object"
            json.required required_fields
            json.properties do
              form.fields.each_pair do |name, value|
                json.method_missing(name) do
                  send("inputtype_#{value.inputtype}", json, value)
                end
              end

            end
          end

          json.Created do
            json.allOf do
              json.child! do 
                json.type "object"
                json.required [ "ref" ]
                json.properties do
                  json.ref do
                    json.type "string"
                  end
                end
              end
            end
          end
        end
      end

    end
  end

  def run
    to_builder.attributes!
  end

  def required_fields
    required_fields = []
    form.fields.each_pair do |name, _|
      required_fields << name.to_s
    end
    required_fields.sort
  end

  def inputtype_textarea(json, _)
    json.type "string"
  end

  def inputtype_text(json, _)
    json.type "string"
  end

  def inputtype_radio(json, value)
    json.type "string"
    json.enum value.items.map(&:value)
  end

  def inputtype_checkboxes(json, value)
    json.type "array"
    json.items do
      json.type "string"
    end
  end

  def inputtype_fieldset(json, value)
  end

  def inputtype_list(json, value)
  end

  def inputtype_image(json, value)
  end
end
