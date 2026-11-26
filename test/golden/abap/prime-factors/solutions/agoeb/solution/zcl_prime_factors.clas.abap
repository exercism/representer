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
    data: residual type int8,
          factor   type int8.

    factor = 2.
    residual = input.

    while factor <= residual.
      if residual MOD factor = 0.
        append factor to result.
        residual = residual / factor.
      else.
        factor = factor + 1.
      endif.
    endwhile.
  ENDMETHOD.


ENDCLASS.