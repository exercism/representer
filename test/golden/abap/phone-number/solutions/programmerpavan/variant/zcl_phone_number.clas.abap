CLASS zcl_phone_number DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS clean
      IMPORTING
        !number       TYPE string
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_phone_number IMPLEMENTATION.

  METHOD clean.
" add your code here
    REPLACE ALL OCCURRENCES OF REGEX '[^0-9]+' IN number WITH space.
    
    CONDENSE number NO-GAPS.
    
    DATA(lv_len) = STRLEN( number ) .
    IF number+0(1) = '1'.
      lv_len = lv_len + 1.
      result = number+1(lv_len).
    else.
      result = number.
    ENDIF.


    IF ( result+0(1) eq '0' or result+0(1) eq '1'   OR  result+3(1) eq '0' or result+3(1) eq '1' ) .
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
    
    IF ( lv_len Ge 11 ) or ( lv_len le 9 ) or result ca 'abc' or result ca ':'.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
