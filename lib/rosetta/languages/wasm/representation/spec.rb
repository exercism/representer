module Rosetta::Languages::Wasm::Representation
  class Spec < Rosetta::Engine::Representation
    version 8

    # Rename every name, without its `$`.
    names_are :identifier, without_prefix: "$" # local.get «$total»

    # Rename the names of modules, types and the fields of a module.
    names_are_defined_by :module,               # (module «$leap» ...)
                         :type_def,             # (type «$pair» (func ...))
                         :field,                # (struct (field «$x» i32))
                         :module_field_func,    # (func «$is_leap» ...)
                         :module_field_global,  # (global «$count» (mut i32) ...)
                         :module_field_memory,  # (memory «$mem» 1)
                         :module_field_table,   # (table «$fns» 2 funcref)
                         :module_field_data,    # (data «$text» (i32.const 0) "abc")
                         :module_field_elem,    # (elem «$items» ...)
                         :module_field_tag      # (tag «$error» (param i32))

    # Rename the names of the functions, globals, memories, tables and tags
    # that a module imports.
    names_are_defined_by :extern_type_func,    # (import "env" "log" (func «$log» ...))
                         :extern_type_global,  # (import "env" "g" (global «$g» i32))
                         :extern_type_memory,  # (import "env" "mem" (memory «$mem» 1))
                         :extern_type_table,   # (import "env" "fns" (table «$fns» 2 funcref))
                         :extern_type_tag      # (import "env" "error" (tag «$error»))

    # Rename parameters and locals.
    names_are_defined_by :param,  # (param «$year» i32)
                         :local   # (local «$total» i32)

    # Rename the labels of blocks, loops and ifs.
    names_are_defined_by :block_block,      # (block «$done» ...)
                         :block_loop,       # (loop «$next» ...)
                         :block_if,         # (if «$check» ...)
                         :block_try_table   # (try_table «$try» ...)
  end
end
