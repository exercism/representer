CLASS zcl_isogram DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS is_isogram
      IMPORTING
        VALUE(phrase)        TYPE string
      RETURNING
        VALUE(result) TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_isogram IMPLEMENTATION.

  METHOD is_isogram.
    data: it_char type table of c.
    do strlen( phrase ) times.
      data(pos) = sy-index.
      data(char) = to_upper( phrase(pos) ).
      if sy-abcde cs char AND count( val = to_upper( phrase ) regex = char ) > 1.
        result = abap_false.
        RETURN.
      endif.  
    enddo.
    result = abap_true.
  ENDMETHOD.

ENDCLASS.
