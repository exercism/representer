# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here removes code that makes no difference to what the solution does.
class Representer::Languages::Typescript::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        drop_empty_statements!(root)
      end
    end

    private
    # Drop each empty statement, except as the first or second part of a
    # `for`, where it shows which part is missing.
    # f();;  ->  f();
    # for (;; i++) and for (i++;;) keep theirs
    def drop_empty_statements!(root)
      each_node(root) do |node, _|
        node.children.reject! do |child|
          child.type == "empty_statement" && child.field != "initializer" && child.field != "condition"
        end
      end
    end
  end
end
