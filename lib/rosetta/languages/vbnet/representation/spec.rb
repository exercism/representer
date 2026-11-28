module Rosetta::Languages::VBNet::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of namespaces and types.
    names_are_defined_by namespace_block: :name,       # Namespace «Shop»
                         module_block: :name,          # Module «Leap»
                         class_block: :name,           # Class «Counter»
                         structure_block: :name,       # Structure «Point»
                         interface_block: :name,       # Interface «IShape»
                         enum_block: :name,            # Enum «Color»
                         delegate_declaration: :name,  # Delegate Function «Apply»(x As Integer) As Integer
                         type_parameter: :name         # Class Box(Of «T»)

    # Rename the names of members.
    names_are_defined_by method_declaration: :name,        # Function «Area»(width As Integer) As Integer
                         method_signature: :name,          # Function «Area»() As Integer
                         property_declaration: :name,      # Property «Count» As Integer
                         property_signature: :name,        # ReadOnly Property «Count» As Integer
                         event_declaration: :name,         # Event «Changed»()
                         custom_event_declaration: :name,  # Custom Event «Changed» As EventHandler
                         declare_declaration: :name,       # Declare Function «Beep» Lib "kernel32" ()
                         enum_member: :name                # Enum Color «Red» = 1

    # Rename fields, local variables and parameters.
    names_are_defined_by variable_declarator: :name,  # Dim «total» As Integer = 0
                         parameter: :name,            # Function Area(«width» As Integer)
                         tuple_element: :name         # Dim pair As («count» As Integer, «name» As String)

    # Rename the variables of loops, `Catch` and queries, and labels.
    names_are_defined_by for_statement: :variable,       # For «i» = 1 To 10
                         for_each_statement: :variable,  # For Each «item» In items
                         catch_clause: :name,            # Catch «e» As Exception
                         range_variable: :name,          # From «word» In words
                         let_clause: :name,              # Let «total» = a + b
                         aggregation: :name,             # Into «total» = Sum(x)
                         label_statement: :label         # «retry»:

    # Drop these imports, because a solution that passes its tests has already
    # made every namespace it needs available.
    imports "Imports {{...}}" # «Imports System.Linq»
  end
end
