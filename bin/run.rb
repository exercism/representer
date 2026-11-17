#!/usr/bin/env ruby

require_relative "../lib/representer"

event = { "body" => File.read(ARGV[0]) }
response = Representer.process(event:, context: {})
puts response.to_json
