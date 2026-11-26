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



CLASS ZCL_COLLATZ_CONJECTURE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COLLATZ_CONJECTURE->RET_STEPS
* +-------------------------------------------------------------------------------------------------+
* | [--->] NUM                            TYPE        I
* | [<-()] STEPS                          TYPE        I
* | [!CX!] CX_PARAMETER_INVALID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ret_steps.
       DATA l_num TYPE i .

l_num = num .

IF l_num = 1 .
steps = 0 .
ELSEIF l_num < 1.

RAISE EXCEPTION TYPE cx_parameter_invalid .

ELSE.



    steps = 0.

    WHILE l_num <> 1.


      IF l_num MOD 2 = 0 .
        l_num = l_num / 2 .
      ELSE.
        l_num = 3 * l_num + 1.
      ENDIF.



      steps = steps + 1 .
    ENDWHILE.
ENDIF.
  ENDMETHOD.
ENDCLASS.