CLASS zcl_darts DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS score
      IMPORTING
        x             TYPE f
        y             TYPE f
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_darts IMPLEMENTATION.
  METHOD score.
  data(r) = sqrt( x * x + y * y ).
    if 0 <= r and r <= 1.
      result = 10.
    elseif 1 < r and r <= 5.
      result = 5. 
    elseif 5 < r and r <= 10.
      result = 1.
    else.
      result = 0.
    endif.
  ENDMETHOD.


ENDCLASS.
