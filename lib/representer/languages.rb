# Finds the representer for a track. Tracks with no class of their own get
# Basic.
module Representer::Languages
  def self.register(track_slug, language) = registry[track_slug] = language
  def self.for(track_slug) = registry.fetch(track_slug, Basic)
  def self.registry = @registry ||= {}
end

require_relative "languages/basic"

# A language on the old structure is one file, such as `languages/python.rb`.
Dir[File.join(__dir__, "languages", "*.rb")].each { |file| require file }

# A staged language is a folder, such as `languages/ruby/`. Its spec.rb
# defines the language, and Engine::Language loads the rest of the folder.
Dir[File.join(__dir__, "languages", "*", "spec.rb")].each { |file| require file }
