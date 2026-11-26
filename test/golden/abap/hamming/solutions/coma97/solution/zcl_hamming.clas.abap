CLASS zcl_hamming DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS hamming_distance
      IMPORTING
        first_strand  TYPE string
        second_strand TYPE string
      RETURNING
        VALUE(result) TYPE i
      RAISING
        cx_parameter_invalid.
ENDCLASS.

CLASS zcl_hamming IMPLEMENTATION.

  METHOD hamming_distance.
    " add solution here
    
    
    IF strlen( first_strand ) = strlen( second_strand ).
      DO strlen( first_strand ) TIMES.  
       DATA: pointer TYPE i.
       pointer = sy-index - 1.
        IF  first_strand+pointer(1) <> second_strand+pointer(1).
          result = result + 1.
        ENDIF.
      ENDDO.    
    ELSE.
    raise exception type cx_parameter_invalid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
