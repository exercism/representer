CLASS zcl_rle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS encode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

    METHODS decode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

ENDCLASS.


CLASS zcl_rle IMPLEMENTATION.

  METHOD encode.
    data(inp) = input.
    while strlen( inp ) > 0.
      find regex '(\w|\s)(\1*)(.*)' in inp submatches data(c) data(l) inp.
      result = |{ result }{ cond string( when strlen( l ) > 0 then condense( strlen( l ) + 1 ) ) }{ c }|.
    endwhile.
  ENDMETHOD.


  METHOD decode.
    data(inp) = input.
    while strlen( inp ) > 0.
      find regex '(\d*)(\w|\s)(.*)' in inp submatches data(c) data(l) inp.
      result = |{ result }{ reduce #( init r = |{ l }| for i = 1 while i < c  next r = |{ r }{ l }| ) }|.
    endwhile.

  ENDMETHOD.

ENDCLASS.