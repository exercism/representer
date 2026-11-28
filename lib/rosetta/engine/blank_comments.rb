module Rosetta::Engine
  # Replaces each comment in the source with spaces, for a grammar that
  # doesn't know the language's comments, as Factor's reads `! a note` as
  # words (see Language.comment_text). A match of outside, such as a string,
  # stays as it is, so a comment marker inside it is still code. Each byte
  # becomes a space, and line breaks stay, so every other node keeps its
  # place in the source.
  class BlankComments
    include Mandate

    initialize_with :source, :pattern, outside: nil

    def call
      matcher = outside ? Regexp.new("(#{outside})|#{pattern}") : pattern
      source.gsub(matcher) do |match|
        next match if outside && Regexp.last_match(1)

        match.gsub(/[^\n]/) { |char| " " * char.bytesize }
      end
    end
  end
end
