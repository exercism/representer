# Finds the representer and the snippet for a track. Tracks with no language
# of their own get Basic, and tracks with no snippet of their own get
# Basic::Snippet.
module Representer::Languages
  def self.register(track_slug, language) = registry[track_slug] = language
  def self.for(track_slug) = registry.fetch(track_slug, Basic)
  def self.registry = @registry ||= {}

  # A track with no language of its own registers its snippet with
  # Engine::Snippet.tracks.
  def self.register_snippet(track_slug, snippet) = snippets[track_slug] = snippet
  def self.snippets = @snippets ||= {}

  # The snippet beside the track's Spec, such as Ruby::Snippet.
  def self.snippet_for(track_slug)
    snippets.fetch(track_slug) do
      language = self.for(track_slug)
      next Basic::Snippet if language == Basic

      language.stages.const_defined?(:Snippet, false) ? language.stages::Snippet : Basic::Snippet
    end
  end
end

require_relative "languages/basic"

# Each language is a folder, such as `languages/ruby/`. Its spec.rb defines
# the language, and Engine::Language loads the rest of the folder.
Dir[File.join(__dir__, "languages", "*", "spec.rb")].each { |file| require file }

# A track with no language of its own can have a folder holding only its
# snippet, such as `languages/lean/snippet.rb`.
Dir[File.join(__dir__, "languages", "*", "snippet.rb")].each do |file|
  require file unless File.exist?(File.join(File.dirname(file), "spec.rb"))
end
