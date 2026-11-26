CLASS zcl_triangle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      is_equilateral
        IMPORTING
          side_a             TYPE f
          side_b             TYPE f
          side_c             TYPE f
        RETURNING
          VALUE(result)      TYPE abap_bool
        RAISING
          cx_parameter_invalid,
      is_isosceles
        IMPORTING
          side_a             TYPE f
          side_b             TYPE f
          side_c             TYPE f
        RETURNING
          VALUE(result)      TYPE abap_bool
        RAISING
          cx_parameter_invalid,
      is_scalene
        IMPORTING
          side_a             TYPE f
          side_b             TYPE f
          side_c             TYPE f
        RETURNING
          VALUE(result)      TYPE abap_bool
        RAISING
          cx_parameter_invalid.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_triangle IMPLEMENTATION.

  METHOD is_equilateral.
    IF ( side_a = 0 AND side_b = 0 AND side_c = 0 ) OR NOT ( side_a + side_b >= side_c AND side_b + side_c >= side_a AND side_c + side_a >= side_b ).
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ELSEIF ( side_a = side_b AND side_b = side_c ).
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD is_isosceles.
    IF ( side_a = 0 AND side_b = 0 AND side_c = 0 ) OR NOT ( side_a + side_b >= side_c AND side_b + side_c >= side_a AND side_c - side_a >= side_b ).
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ELSEIF NOT ( side_a <> side_b AND side_b <> side_c AND side_c <> side_a ).
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD is_scalene.
    IF ( side_a = 0 AND side_b = 0 AND side_c = 0 ) OR NOT ( side_a + side_b >= side_c AND side_b + side_c >= side_a AND side_c + side_a >= side_b ).
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ELSEIF ( side_a <> side_b AND side_b <> side_c AND side_c <> side_a ).
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
