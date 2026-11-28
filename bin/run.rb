#!/usr/bin/env ruby

require_relative "../lib/rosetta"

event = { "body" => File.read(ARGV[0]) }
response = Rosetta.process(event:, context: {})
puts response.to_json
