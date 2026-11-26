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

DATA: new_num TYPE i,
      count TYPE i,
      count_2 TYPE i.

IF num < 1.
RAISE EXCEPTION TYPE cx_parameter_invalid.
ELSEIF num = 1.
count = 0.
ELSEIF num MOD 2 = 0.
new_num = num / 2.
count = 1.
ELSE.
new_num = ( num * 3 ) + 1.
count = 1.
ENDIF.
WRITE: / new_num.


IF new_num = 1.
count_2 = 0.
ELSE.
WHILE new_num > 1.
IF new_num MOD 2 = 0.
new_num = new_num * 2.
count_2 = sy-index.
ELSE.
new_num = ( new_num * 3 ) + 1.
count_2 = sy-index.
ENDIF.
WRITE: / new_num.
ENDWHILE.
ENDIF.

steps = count + count_2.

WRITE: / 'Steps till 1: ', steps.


  ENDMETHOD.

ENDCLASS.
