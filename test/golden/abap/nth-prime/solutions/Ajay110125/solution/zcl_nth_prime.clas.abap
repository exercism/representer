CLASS zcl_nth_prime DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS prime
      IMPORTING
        input         TYPE i
      RETURNING
        VALUE(result) TYPE i
      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_nth_prime IMPLEMENTATION.
  METHOD prime.
    " add solution here
    IF input EQ 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ELSEIF input EQ 1.
      result = 2.
    ELSE.
      DATA : l_i     TYPE i,
             l_count TYPE i VALUE 0,
             l_num   TYPE i VALUE 1.

      WHILE l_count < input.
        l_num = l_num + 1.

        l_i = 2.
        WHILE l_i < l_num.
          IF l_num MOD l_i EQ 0.
            EXIT.
          ENDIF.
          l_i = l_i + 1.
        ENDWHILE.

        IF l_i EQ l_num.
          l_count = l_count + 1.
        ENDIF.
      ENDWHILE.

      result = l_num.
    ENDIF.
  ENDMETHOD.


ENDCLASS.
