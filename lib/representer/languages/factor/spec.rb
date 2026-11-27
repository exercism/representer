module Representer::Languages::Factor
  class Spec < Representer::Engine::Language
    tracks "factor"
    grammar "factor"
    extensions ".factor"

    # A comment runs from a `!` or `#!` word to the end of the line. A string
    # comes first, so a `!` inside one stays.
    COMMENTS = /"(?:\\.|[^"\\])*"|(?<!\S)#?!(?=\s|\z)[^\n]*/m

    # Drop the comments from each file before parsing it, because the grammar
    # reads them as words. The files are parsed again, because any trees
    # already parsed still hold the comments.
    # : f ( -- n ) 1 ; ! The answer  ->  : f ( -- n ) 1 ;
    def self.call(solution_files, **) = super(solution_files.transform_values { |source| without_comments(source) })

    def self.without_comments(source)
      Representer::Engine.clean(source).gsub(COMMENTS) { |match| match.start_with?('"') ? match : "" }
    end
  end
end
