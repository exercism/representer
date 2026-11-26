CLASS zcl_armstrong_numbers DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS is_armstrong_number
      IMPORTING
        num           TYPE i
      RETURNING
        VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS zcl_armstrong_numbers IMPLEMENTATION.
  METHOD is_armstrong_number.
    DATA(str) = CONV string( num ).
    DATA(len) = strlen( str ) - 1.
    DATA(aux) = 0.
    
    DO len TIMES.
      DATA(idx) = sy-index - 1.
      DATA(digit) = CONV i( str-idx(1) ).
      aux += ipow( base = digit exp = len ).
    ENDDO.

    IF num = aux.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
