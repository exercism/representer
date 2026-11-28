module Inspector::Languages::PharoSmalltalk::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename these names. A symbol names a selector or a class, so it gets
    # the same placeholder as the method or class it names.
    names_are :identifier,       # «count» := 0
              :unary_selector,   # list «size»
              :keyword_selector  # list «at:put:» 1 2
    names_are :symbol, without_prefix: "#" # list collect: #«first»

    # Rename the names that the solution defines: its classes and their
    # variables, its methods, their parameters and temporaries, and the
    # parameters of blocks.
    names_are_defined_by :class_name,      # #name : «#Robot»
                         :variable_names,  # #instVars : [ «'position'» ]
                         :parameter,       # at: «index» put: «value» [ ]
                         :temporary,       # | «sum» |
                         :block_parameter, # [ :«each» | each ]
                         :unary_pattern,   # Robot >> «move» [ ]
                         keyword_pattern: :selector # Robot >> «at:put:» i v [ ]
  end
end
