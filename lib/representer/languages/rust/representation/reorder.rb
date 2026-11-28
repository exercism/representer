# REPRESENTER_DSL.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::Rust::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the items of a file, and the items inside an impl, a trait or a
    # module. Normalise has already moved each attribute into its item.
    # fn a() {} fn b() {} == fn b() {} fn a() {}
    sort :source_file, :declaration_list
  end
end
