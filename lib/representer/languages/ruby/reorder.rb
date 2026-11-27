# Ruby's Reorder stage sorts code if its order makes no difference:
#
# - It sorts the methods and other code in the body of each class and
#   module. Normalise has already marked each method with its visibility,
#   so a method keeps its visibility wherever it moves.
# - It sorts the entries of each hash.
#
# Each sorts by the code with every renamed name left out, so two solutions
# that only name things differently get the same order.
module Representer
  module Languages
    module Ruby
      class Reorder < Engine::Reorder
        sort :class_body, :module_body, :hash
      end
    end
  end
end
