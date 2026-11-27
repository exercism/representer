module Representer::Languages::Sml
  class Representation < Representer::Engine::Representation
    version 6

    # Rename values, functions, constructors, exceptions, record labels,
    # types, type variables, structures, signatures and functors.
    names_are :vid,    # «count»
              :lab,    # {«width» = 1}
              :tycon,  # «shape»
              :tyvar,  # «'a» list
              :strid,  # «Counter».reset
              :sigid,  # structure Counter : «COUNTER»
              :fctid   # «Make»(Counter)

    # Rename the names of functions and values, and the variables in
    # patterns.
    names_are_defined_by :var_pat,         # val «total» = ...
                         fmrule: :name,    # fun «area» width = ...
                         valdesc: :name    # val «area» : int -> int

    # Rename the names of constructors, exceptions and record labels.
    names_are_defined_by conbind: :name,  # datatype shape = «Circle» of real
                         condesc: :name,  # datatype shape = «Circle» of real
                         exbind: :name,   # exception «Oops»
                         exdesc: :name,   # exception «Oops»
                         exprow: :label,  # {«width» = 1}
                         patrow: :label,  # fun area {«width» = w} = w
                         tyrow: :label    # type size = {«width» : int}

    # Rename the names of types and type variables.
    names_are_defined_by :tyvar_ty,              # fun first (xs : «'a» list) = ...
                         :tyvarseq,              # datatype «'a» tree = ...
                         datbind: :name,         # datatype «shape» = ...
                         datdesc: :name,         # datatype «shape» = ...
                         typbind: :name,         # type «size» = int
                         typedesc: :name,        # type «size»
                         datarepl_dec: :name,    # datatype «order» = datatype General.order
                         datarepl_spec: :name    # datatype «order» = datatype General.order

    # Rename the names of structures, signatures and functors.
    names_are_defined_by strbind: :name,  # structure «Counter» = struct ... end
                         strdesc: :name,  # structure «Counter» : COUNTER
                         sigbind: :name,  # signature «COUNTER» = sig ... end
                         fctbind: :name   # functor «Make» («X» : S) = struct ... end

    # Drop the opens, because a solution that passes its tests has already
    # opened every structure it needs.
    imports "open {{...}}" # «open List»
  end
end
