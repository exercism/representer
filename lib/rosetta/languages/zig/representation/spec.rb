module Rosetta::Languages::Zig::Representation
  class Spec < Rosetta::Engine::Representation
    version 10

    # Rename identifiers.
    names_are :IDENTIFIER # «count»

    # Rename the names of functions, constants and variables.
    names_are_defined_by FnProto: :function,                    # fn «isLeapYear»(year: u32) bool { ... }
                         VarDecl: :variable_type_function,      # const «Point» = struct { ... };
                         VarDeclProto: :variable_type_function  # const «a», const «b» = pair;

    # Rename parameters, and the variables of payloads and labels.
    names_are_defined_by :Payload,                # catch |«err»| return err
                         :PtrPayload,             # if (maybe) |«value»| { ... }
                         :PtrIndexPayload,        # switch (x) { .a => |«value»| ... }
                         :PtrListPayload,         # for (items, 0..) |«item», «i»| { ... }
                         :BlockLabel,             # «outer»: while (true) { ... }
                         ParamDecl: :parameter    # fn f(«year»: u32) bool { ... }

    # Rename struct fields, the values of an enum, and error names.
    names_are_defined_by :ContainerField,  # struct { «x»: i32 }, enum { «red», «blue» }
                         :ErrorSetDecl     # error{ «Overflow» }

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs.
    imports 'const {{_}} = @import("{{_}}");',            # «const std = @import("std");»
            'const {{_}} = @import("{{_}}").{{_}};',      # «const math = @import("std").math;»
            'const {{_}} = @import("{{_}}").{{_}}.{{_}};' # «const print = @import("std").debug.print;»
  end
end
