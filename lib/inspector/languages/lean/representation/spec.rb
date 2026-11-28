module Inspector::Languages::Lean::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename names, and the parts of dotted names.
    names_are :identifier # «count»

    # Rename a name that starts with a dot, such as a constructor or a
    # field, as the name without the dot.
    names_are :dot_identifier, # .«red»
              :field,          # (f x).«length»
        without_prefix: "."

    # Rename the names of namespaces, sections and universes.
    names_are_defined_by :universe,        # universe «u»
                         namespace: :name, # namespace «Leap»
                         section: :name    # section «Helpers»

    # Rename the names of definitions and local functions, their
    # parameters, the variables that patterns bind, and the names of
    # proofs.
    names_are_defined_by :variable_pattern,           # def area «width» «height» := ...
                         definition: :name,           # def «area» (width height : Nat) := ...
                         where_declaration: :name,    # where «go» n := ...
                         let_statement: :name,        # let «total» := 0
                         have_statement: :name,       # have «h» : n > 0 := ...
                         named_pattern: :name,        # | «all»@(x :: xs) => ...
                         subtype: :name,              # { «n» : Nat // n > 0 }
                         for_statement: :proof,       # for «h» : i in [0:n] do
                         while_statement: :proof,     # while «h» : i < n do
                         if_expression: :proof,       # if «h» : i < n then
                         match_discriminant: :proof   # match «h» : xs with

    # Rename the names that binders define.
    names_are_defined_by explicit_binder: :name,        # («width» «height» : Nat)
                         implicit_binder: :name,        # {«α» : Type}
                         strict_implicit_binder: :name, # ⦃«α» : Type⦄
                         instance_binder: :name         # [«inst» : BEq α]

    # Rename the names of structures, classes, inductive types and
    # instances, and of their fields and constructors.
    names_are_defined_by structure: :name,        # structure «Clock» where
                         structure_field: :name,  # «hour» «minute» : Nat
                         constructor_name: :name, # «mk» ::
                         inductive: :name,        # inductive «Color» where
                         constructor: :name,      # | «red»
                         instance: :name          # instance «instBEqClock» : BEq Clock where

    # Drop these imports, because a solution that passes its tests has
    # already imported every module it needs and opened every namespace.
    imports "import {{_}}",          # «import Std»
            "open {{...}}",          # «open Std Nat»
            "open {{...}} ({{...}})" # «open Std (HashMap)»
  end
end
