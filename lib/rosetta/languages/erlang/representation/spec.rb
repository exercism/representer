module Rosetta::Languages::Erlang::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename variables and atoms. Erlang names its modules, functions,
    # records, fields, types and macros with atoms, and some macros with
    # variables.
    names_are :var,  # «Year»
              :atom  # «leap_year»

    # Rename the names of the module, functions, records, their fields,
    # types and macros.
    names_are_defined_by module_attribute: :name, # -module(«leap»).
                         function_clause: :name,  # «leap_year»(Year) -> ...
                         record_decl: :name,      # -record(«account», {balance = 0}).
                         record_field: :name,     # -record(account, {«balance» = 0}).
                         type_name: :name,        # -type «year»() :: integer().
                         macro_lhs: :name,        # -define(«LIMIT», 10).
                         callback: :fun           # -callback «init»(term()) -> ok.

    # Rename every variable.
    names_are_defined_by :variable # «Total» = Price * 2

    # Drop these imports, because a solution that passes its tests has already
    # loaded every module and header it needs.
    imports "-import({{_}}, [{{...}}/{{...}}]).", # «-import(lists, [map/2]).»
            '-include("{{_}}").',                 # «-include("leap.hrl").»
            '-include_lib("{{_}}").'              # «-include_lib("eunit/include/eunit.hrl").»
  end
end
