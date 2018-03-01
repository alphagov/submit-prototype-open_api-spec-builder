Submit Prototype OpenAPI generator
===============================================

A proof of concept tool to convert a JSON version of the
[Submit data model](https://github.com/alphagov/submit-forms) into an
[OpenAPI 3.0](https://github.com/OAI/OpenAPI-Specification) spec. There
are more examples of the Submit data model in the
[submit-prototype-kit repo](https://github.com/alphagov/submit-prototype-kit/tree/master/examples).

Useage
------

    $ bin/to_openapi.rb example/apply-for-a-medal.json

Swagger
-------

Swagger is a suite of tools for working with OpenAPI specifications, the
[editor](https://editor.swagger.io/) tool is useful to visualise the output
of this tool.
