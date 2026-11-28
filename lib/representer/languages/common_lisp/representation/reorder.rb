# REPRESENTER_DSL.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Representer::Languages::CommonLisp::Representation
  class Reorder < Representer::Engine::Reorder
    # Reorder the options of each `defpackage`.
    # (defpackage :p (:shadow :x) (:nicknames :q)) == (defpackage :p (:nicknames :q) (:shadow :x))
    sort :package_options
  end
end
