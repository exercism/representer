require "test_helper"

# Snippets for the snippet commands' tests. RubySnippet has Ruby's grammar,
# and LinesSnippet has none.
module SnippetRules
  module Toy
    module Common
      class Spec < Representer::Engine::Language
        grammar "ruby"
      end
    end

    module Snippet
      class Spec < Representer::Engine::Snippet
        remove :comments
        skip_at_top :require
      end
    end
  end

  RubySnippet = Toy::Snippet::Spec

  module Lines
    module Snippet
      class Spec < Representer::Engine::Snippet
        remove :comments
        comment_lines "//", "/*" => "*/"
        skip_at_top :import, "BEGIN" => "END"
        skip_at_bottom :end
      end
    end
  end

  LinesSnippet = Lines::Snippet::Spec

  def self.parse(source) = Representer::Engine::Grammar["ruby"].parse(source, spans: true)
end
