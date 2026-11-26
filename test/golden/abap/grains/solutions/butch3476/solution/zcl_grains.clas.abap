CLASS zcl_grains DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES type_result TYPE p LENGTH 16 DECIMALS 0.
    METHODS square
      IMPORTING
        input         TYPE i
      RETURNING
        VALUE(result) TYPE type_result
      RAISING
        cx_parameter_invalid.
    METHODS total
      RETURNING
        VALUE(result) TYPE type_result
      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_grains IMPLEMENTATION.
  METHOD square.
    " add solution here
        if input < 1 or input > 64.
      raise exception type cx_parameter_invalid.
    else.
      result = 2 ** ( input - 1 ).
    endif.
  ENDMETHOD.

  METHOD total.
    " add solution here
        do 64 times.
      result = result + me->square( sy-index ).
    enddo.
  ENDMETHOD.


ENDCLASS.
