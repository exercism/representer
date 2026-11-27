# REPRESENTER_DSL.md defines the helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
class Representer::Languages::Factor::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        drop_imports!(root)
      end
    end

    private
    # Drop each `USING:` and `USE:`, because a solution that passes its tests
    # has already made every vocabulary it needs available. The grammar's tree
    # is a flat list of words, so no code pattern can match an import, and
    # representation.rb can't list them.
    # USING: kernel math ;  ->
    # USE: io  ->
    def drop_imports!(root)
      drop(root, "[(using) (use)]")
    end
  end
end
