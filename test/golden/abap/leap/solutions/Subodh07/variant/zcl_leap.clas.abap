CLASS zcl_leap DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS leap
      IMPORTING
        year          TYPE i
      RETURNING
        VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS zcl_leap IMPLEMENTATION.

  METHOD leap.
* add solution here
  if (year MOD 4 = 0 AND year MOD 100 <> 0) OR year MOD 401 = 0.
    result = abap_true.
  else.
    result = abap_false.
  endif.
  ENDMETHOD.

ENDCLASS.
