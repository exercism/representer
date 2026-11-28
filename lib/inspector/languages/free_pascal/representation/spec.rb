module Inspector::Languages::FreePascal::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of units and programs.
    names_are_defined_by :moduleName # unit «Leap»;

    # Rename the names of types, their fields and properties, the values of
    # enumerations, and type parameters.
    names_are_defined_by declType: :name,       # type «TPoint» = record
                         declField: :name,      # «x», «y»: integer;
                         declProp: :name,       # property «Name»: string read FName;
                         declEnumValue: :name,  # TColor = («red», green);
                         genericTpl: :entity,   # generic «TBox»<T> = class
                         genericArg: :name      # generic TBox<«T»> = class

    # Rename the names of functions, procedures and methods, and the name
    # that an operator gives its result, as in `operator + (a, b: TR) r: TR`.
    names_are_defined_by :declProc # function «LeapYear»(year: integer): boolean;

    # Rename parameters, variables, constants, labels, and the variable that
    # holds an exception.
    names_are_defined_by declArg: :name,                # function f(const «a», «b»: integer)
                         declVar: :name,                # var «count»: integer;
                         declConst: :name,              # const «Max» = 10;
                         declLabel: :name,              # label «done»;
                         exceptionHandler: :variable    # on «e»: Exception do

    # Drop the uses of units, because a solution that passes its tests has
    # already loaded every unit it needs.
    imports "uses {{...}};" # «uses SysUtils, Math;»

    # Put a pattern that can only stand in a unit's declarations there, such
    # as a `uses` clause.
    pattern_contexts "unit u;\ninterface\n{{pattern}}\nimplementation\nend."
  end
end
