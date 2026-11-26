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
    if num <= 0. 
      raise exception type cx_parameter_invalid.
    endif.
    do.
      if num = 1.
        return.
      endif.
      case num mod 2.
        when 0.
          num = num / 2.
        when others.
          num = 3 * num + 1.
      endcase.
      steps = steps + 1.
    enddo.
  ENDMETHOD.
ENDCLASS.
