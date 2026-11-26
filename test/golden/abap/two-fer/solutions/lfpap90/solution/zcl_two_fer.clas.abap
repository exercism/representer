CLASS zcl_two_fer DEFINITION.
  PUBLIC SECTION.
    METHODS two_fer
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_two_fer IMPLEMENTATION.

  METHOD two_fer.
    DATA: lv_str1 type string,
          lv_str2 type string.

    IF input IS INITIAL.
      input = 'you'.
    ENDIF.

    lv_str1 = 'One for'.
    lv_str2 = 'one for me.'.
  CONCATENATE lv_str1 input INTO result SEPARATED BY SPACE.
  CONCATENATE result lv_str2 INTO result SEPARATED BY ', '.


  ENDMETHOD.

ENDCLASS.