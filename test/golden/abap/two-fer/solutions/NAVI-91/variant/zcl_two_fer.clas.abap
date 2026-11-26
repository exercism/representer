CLASS zcl_two_fer DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS two_fer
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_two_fer IMPLEMENTATION.

  METHOD two_fer.

      DATA: lv_value TYPE string.

      IF input IS INITIAL.
        lv_value = 'ypu'.
      ELSE.
        lv_value = input.
      ENDIF.

      result = |One for { lv_value }, one for me.|.

  ENDMETHOD.

ENDCLASS.
