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
    DATA(lv) = to_lower( phrase ).
    REPLACE ALL OCCURRENCES OF '-' IN lv WITH ''.
    CONDENSE lv NO-GAPS.
    DO strlen( lv ) TIMES.
      DATA(letter) = lv-0(1).
      SHIFT lv BY 1 PLACES.
      FIND letter IN lv.
      IF sy-subrc = 0.
        result = abap_false.
        RETURN.
      ENDIF.
    ENDDO.
    result = abap_true.
  ENDMETHOD.

ENDCLASS.
