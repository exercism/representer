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

     WHILE num NE 1.
IF num < 1.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
      IF num MOD 2 EQ 0.
        num = num / 2.
      ELSE.
        num = ( 3 * num ) + 1.
      ENDIF.
      steps += 1.

    ENDWHILE.


  ENDMETHOD.
ENDCLASS.
