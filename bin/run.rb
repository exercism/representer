#!/usr/bin/env ruby

require_relative "../lib/inspector"

event = { "body" => File.read(ARGV[0]) }
response = Inspector.process(event:, context: {})
puts response.to_json
