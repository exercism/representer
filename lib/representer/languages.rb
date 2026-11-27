# Finds the representer and the snippet for a track. Tracks with no class of
# their own get Basic, and tracks with no snippet of their own get
# Basic::Snippet.
module Representer::Languages
  def self.register(track_slug, language) = registry[track_slug] = language
  def self.for(track_slug) = registry.fetch(track_slug, Basic)
  def self.registry = @registry ||= {}

  # A track with no class of its own registers its snippet with
  # Engine::Snippet.tracks.
  def self.register_snippet(track_slug, snippet) = snippets[track_slug] = snippet
  def self.snippets = @snippets ||= {}

  # The snippet beside the track's Spec, or inside its class, such as
  # Ruby::Snippet or Python::Snippet.
  def self.snippet_for(track_slug)
    snippets.fetch(track_slug) do
      language = self.for(track_slug)
      owner = language.respond_to?(:stages) ? language.stages : language
      owner.const_defined?(:Snippet, false) ? owner::Snippet : Basic::Snippet
    end
  end
end

require_relative "languages/basic"

# A language on the old structure is one file, such as `languages/python.rb`.
Dir[File.join(__dir__, "languages", "*.rb")].each { |file| require file }

# A staged language is a folder, such as `languages/ruby/`. Its spec.rb
# defines the language, and Engine::Language loads the rest of the folder.
Dir[File.join(__dir__, "languages", "*", "spec.rb")].each { |file| require file }

# Every other language has a folder holding only its snippet, such as
# `languages/python/snippet.rb`. A staged language loads its own (see
# Engine::Language).
Dir[File.join(__dir__, "languages", "*", "snippet.rb")].each do |file|
  require file unless File.exist?(File.join(File.dirname(file), "spec.rb"))
end
