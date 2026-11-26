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

      if num co '1234567890' and num ne 0.
if num eq 1.
else.
        while num gt 1.
          if num mod 2 eq 0.
            num = num / 2.
          else.
            num = ( 3 * num ) + 1.
          endif.
steps = steps + 1.
        endwhile.
endif.
      else.
          raise exception type cx_parameter_invalid.
      endif.

  ENDMETHOD.
ENDCLASS.
