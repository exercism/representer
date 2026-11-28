# Finds Rosetta and the snippet for a track. Tracks with no language
# of their own get Basic, and tracks with no snippet of their own get
# Basic::Snippet::Spec.
module Rosetta::Languages
  def self.register(track_slug, language) = registry[track_slug] = language
  def self.for(track_slug) = registry.fetch(track_slug, Basic)
  def self.registry = @registry ||= {}

  # A track with no language of its own registers its snippet with
  # Engine::Snippet.tracks.
  def self.register_snippet(track_slug, snippet) = snippets[track_slug] = snippet
  def self.snippets = @snippets ||= {}

  # The snippet of the track's language, such as Ruby::Snippet::Spec.
  def self.snippet_for(track_slug)
    snippets.fetch(track_slug) do
      language = self.for(track_slug)
      next Basic::Snippet::Spec if language == Basic

      language.snippet || Basic::Snippet::Spec
    end
  end

  # Each language's files start with the module inside the language, such
  # as `module Rosetta::Languages::Ruby::Common`, so Ruby asks for the
  # language's own module first. If the language has a folder, this makes
  # the module.
  # Ruby  ->  `languages/ruby/`
  def self.const_missing(name)
    return super unless File.directory?(Rosetta::Engine.folder_named("#{self.name}::#{name}"))

    const_set(name, Module.new)
  end
end

require_relative "languages/basic"

# Each language is a folder, such as `languages/ruby/`. Its common/spec.rb
# defines the language, and Engine::Language loads the rest of the folder.
Dir[File.join(__dir__, "languages", "*", "common", "spec.rb")].each { |file| require file }

# A track with no language of its own can have a folder holding only its
# snippet, such as `languages/lean/snippet/spec.rb`.
Dir[File.join(__dir__, "languages", "*", "snippet", "spec.rb")].each do |file|
  require file unless File.exist?(File.join(File.dirname(file), "..", "common", "spec.rb"))
end
