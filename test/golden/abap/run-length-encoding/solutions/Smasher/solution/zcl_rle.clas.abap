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

    DATA: char2       TYPE string,
          duplicates TYPE string.
    DATA(str) = input.
    WHILE str IS NOT INITIAL.
      FIND REGEX '([\w|\s])(\1*)(.*)' IN str SUBMATCHES char2 duplicates str  ##SUBRC_OK.
      IF duplicates IS NOT INITIAL.
        result = |{ result }{ strlen( duplicates ) + 1 }{ char2 }|.
      ELSE.
        result = |{ result }{ char2 }|.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.


  METHOD decode.

    DATA: char2 TYPE string,
          reps TYPE string.
    DATA(str) = input.
    WHILE str IS NOT INITIAL.
      FIND REGEX '(\d*)([\w|\s])(.*)' IN str SUBMATCHES reps char2 str  ##SUBRC_OK.
      IF reps IS NOT INITIAL.
        result = |{ result }{ repeat( val = char2 occ = reps ) }|.
      ELSE.
        result = |{ result }{ char2 }|.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.

ENDCLASS.
