module Rosetta::Languages::Abap::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers and field symbols.
    names_are :identifier,  # «count»
              :field_symbol # «<line>»

    # Rename the names of classes, interfaces, methods, events and forms.
    names_are_defined_by class_declaration: :name,          # CLASS «zcl_leap» DEFINITION.
                         class_implementation: :name,       # CLASS «zcl_leap» IMPLEMENTATION.
                         deferred_class_declaration: :name, # CLASS «lcl_helper» DEFINITION DEFERRED.
                         interface_declaration: :name,      # INTERFACE «lif_shape».
                         method_spec: :name,                # METHODS «leap» IMPORTING year TYPE i.
                         method_implementation: :name,      # METHOD «leap».
                         event_spec: :name,                 # EVENTS «changed».
                         form_definition: :name             # FORM «helper».

    # Rename parameters, types, structure components, variables and constants.
    names_are_defined_by implicit_reference: :name,     # IMPORTING «year» TYPE i
                         explicit_value: :name,         # RETURNING VALUE(«result») TYPE abap_bool
                         explicit_reference: :name,     # EXPORTING REFERENCE(«count») TYPE i
                         types_spec: :name,             # TYPES «ty_line» TYPE string.
                         begin_of_struct_spec: :name,   # TYPES BEGIN OF «ty_pair».
                         end_of_struct_spec: :name,     # TYPES END OF «ty_pair».
                         data_spec: :name,              # DATA «count» TYPE i.
                         class_data_spec: :name,        # CLASS-DATA «cache» TYPE string.
                         statics_spec: :name,           # STATICS «calls» TYPE i.
                         constants_spec: :name,         # CONSTANTS «c_max» TYPE i VALUE 10.
                         field_symbols_spec: :name,     # FIELD-SYMBOLS «<line>» TYPE string.
                         declaration_expression: :name  # DATA(«count») = 0.

    # Rename the variables of FOR, the accumulators of REDUCE, the components
    # of group keys, and the names given by LET. ABAP needs every variable to
    # be declared, so a plain name on the left of an assignment is always a
    # name defined by the solution.
    names_are_defined_by table_iteration: :work_area,   # FOR «line» IN lines
                         index_into_spec: :enumerator,  # FOR line IN lines INDEX INTO «index»
                         accumulator_spec: :name,       # INIT «sum» = 0
                         group_key_component: :field,   # GROUP BY ( «key» = line-key )
                         assignment: :left              # LET «half» = n / 2 IN
  end
end
