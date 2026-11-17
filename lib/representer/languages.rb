module Representer
  # Finds the representer for a track. Tracks with no class of their own get
  # Basic.
  module Languages
    def self.register(track_slug, language) = registry[track_slug] = language
    def self.for(track_slug) = registry.fetch(track_slug, Basic)
    def self.registry = @registry ||= {}
  end
end

require_relative "languages/basic"
Dir[File.join(__dir__, "languages", "*.rb")].each { |file| require file }
