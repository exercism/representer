module Rosetta::Languages::Prolog::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename variables and atoms. Prolog names its predicates with atoms.
    names_are :variable_term, # «Year»
              :atom           # «leap»

    # Rename the predicates that the solution's clauses define.
    names_are_defined_by head: :function # «leap»(Year) :- ...

    # Rename every variable.
    names_are_defined_by :variable # «Total» is Price * 2

    # Drop these imports, because a solution that passes its tests has already
    # loaded every library it needs.
    imports ":- use_module({{...}}).",   # «:- use_module(library(lists)).»
            ":- ensure_loaded({{...}})." # «:- ensure_loaded(library(lists)).»
  end
end
