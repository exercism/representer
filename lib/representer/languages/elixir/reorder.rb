# Elixir's Reorder stage sorts code if its order makes no difference:
#
# - It sorts the code in the body of each module. This keeps the old
#   representer's (exercism/elixir-representer) sorting of the `use`
#   statements at the start of a module, and also sorts the functions.
#   Normalise has already moved each `@spec` into its function, so a spec
#   moves with its function.
# - It sorts the entries of each map and struct, also after the `|` in
#   `%{map | a: 1}`, as the old representer did.
#
# Each sorts by the code with every renamed name left out, so two solutions
# that only name things differently get the same order.
module Representer
  module Languages
    module Elixir
      class Reorder < Engine::Reorder
        sort :module_body, :map_content, :map_update
      end
    end
  end
end
