# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to statements that Wren reads the same way.
class Representer::Languages::Wren::Representation
  class Normalise < Representer::Engine::Normalise
    BODIES = {
      "if_statement" => ["consequence", "alternative"],
      "while_statement" => ["body"],
      "for_statement" => ["body"]
    }.freeze

    def call
      super.tap do |root|
        put_braces_around_each_body!(root)
      end
    end

    private
    # Put braces around the body of each `if`, `else`, `while` and `for`,
    # including an `else if`. The grammar reads the empty braces of an
    # `add_braces_to` pattern as an empty map, so this step finds the bodies
    # itself.
    #
    # if (a) b()  ->  if (a) { b() }
    # if (a) b() else if (c) d()  ->  if (a) { b() } else { if (c) { d() } }
    # for (i in xs) f(i)  ->  for (i in xs) { f(i) }
    def put_braces_around_each_body!(root)
      each_node(root) do |node, _|
        BODIES.fetch(node.type, []).each do |field|
          body = node[field]
          next if body.nil? || body.type == "block"

          node.replace_child(body, build(:block, copy(body).tap { |statement| statement.field = nil }))
        end
      end
    end
  end
end
