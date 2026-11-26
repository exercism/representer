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
    "Add solution here
    DATA(remaining_string) = input.
    WHILE remaining_string IS NOT INITIAL.
      FIND REGEX '([\w\s])' " all letters and whitespace
              && '(\1*)'    " followed by the finding from above, zero or more times
              && '(.*)'     " the remaining string
        IN remaining_string
        SUBMATCHES DATA(letter)  DATA(multiples)  remaining_string.
      IF multiples IS INITIAL.
        result = |{ result }{ letter }|.
      ELSE.
        result = |{ result }{ strlen( multiples ) + 1 }{ letter }|.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.


  METHOD decode.
    "Add solution here
    DATA(remaining_string) = input.
    WHILE remaining_string IS NOT INITIAL.
      FIND REGEX '(\d*)([\w\s])(.*)' " a number followed by a 'letter', zero or more times
        IN remaining_string
        SUBMATCHES DATA(cnt)  DATA(letter)  remaining_string.
      IF cnt IS INITIAL.
        result = |{ result }{ letter }|.
      ELSE.
        result = |{ result }{ repeat( val = letter  occ = cnt ) }|.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
