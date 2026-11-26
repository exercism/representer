CLASS zcl_reverse_string DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS reverse_string
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_reverse_string IMPLEMENTATION.

  METHOD reverse_string.
    " Please complete the implementation of the reverse_string method
   " data lv_length type i.
   " lv_length = strlen( input ) - 1.
   " while lv_length >= 0.
   "   result = result && input+lv_length(1). 
   "   lv_length = lv_length - 1.
   " endwhile.
   result = reverse( input ).
  ENDMETHOD.

ENDCLASS.