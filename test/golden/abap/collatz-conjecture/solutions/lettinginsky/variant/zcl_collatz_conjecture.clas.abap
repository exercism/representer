CLASS zcl_collatz_conjecture DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS ret_steps IMPORTING num          TYPE i
                      RETURNING VALUE(steps) TYPE i
                      RAISING   cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_collatz_conjecture IMPLEMENTATION.
  METHOD ret_steps.
    DATA: lv_num   TYPE i,
          lv_steps TYPE i VALUE 0.

    " Validate input: num must be greater than 0
    IF num <= 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.

    " Copy num so we don't change the original
    lv_num = num.

    " Loop until we reach 1
    WHILE lv_num <> 1.
      IF lv_num MOD 2 = 0.
        lv_num = lv_num / 2.
      ELSE.
        lv_num = lv_num / 3 + 1.
      ENDIF.

      lv_steps = lv_steps + 1.
    ENDWHILE.

    steps = lv_steps.
  ENDMETHOD.

ENDCLASS.
