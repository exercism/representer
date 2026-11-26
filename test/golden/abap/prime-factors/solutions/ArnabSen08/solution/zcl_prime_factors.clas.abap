CLASS zcl_prime_factors DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS factors
      IMPORTING
        input         TYPE int8
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_prime_factors IMPLEMENTATION.
  METHOD factors.
    " add solution here
  DATA(lv_number) = input.
    DATA(lv_factor) = 2.
    WHILE lv_number <> 1.
      IF lv_number MOD lv_factor = 0.
        lv_number = lv_number / lv_factor.
        INSERT lv_factor INTO TABLE result.
        CONTINUE.
      ENDIF.
      lv_factor = lv_factor + 1.
    ENDWHILE.
  ENDMETHOD.


ENDCLASS.
