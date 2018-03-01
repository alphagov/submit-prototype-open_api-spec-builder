#!/usr/bin/env ruby

require_relative "../lib/open_api_spec_builder.rb"

file = File.read(ARGV[0])
puts OpenAPISpecBuiler.new(file).run.to_json
