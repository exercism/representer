# REPRESENTER_DSL.md defines the helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
class Representer::Languages::Ballerina::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        drop_imports!(root)
      end
    end

    private
    # Drop each import, because a solution that passes its tests has already
    # imported every module it needs. The grammar's tree is a flat list of
    # tokens, so no code pattern can match an import, and representation.rb
    # can't list them.
    # import ballerina/io;  ->
    def drop_imports!(root)
      drop(root, "(import_declaration)")
    end
  end
end
