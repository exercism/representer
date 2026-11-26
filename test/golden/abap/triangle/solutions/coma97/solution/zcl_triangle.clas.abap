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
          cx_parameter_invalid,
"added a method based on the note of Instructions to prevoiusly check if is a valid triangle
      is_triangle
        importing
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
   if is_triangle( side_a = side_a
                       side_b = side_b
                       side_c = side_c ). 
    else.
      raise exception type cx_parameter_invalid.
    endif. 
  "An equilateral triangle has all three sides the same length  
  if ( side_a = side_b and side_b = side_c ).
      result = abap_true.
  else.
      result = abap_false.
  endif.
  ENDMETHOD.

  METHOD is_isosceles.
   if is_triangle( side_a = side_a
                       side_b = side_b
                       side_c = side_c ). 
    else.
      raise exception type cx_parameter_invalid.
    endif.
    "An isosceles triangle has at least two sides the same length.
    if ( side_a = side_b or side_b = side_c or side_a = side_c ).
       result = abap_true.
    else.
      result = abap_false.
    endif.
  ENDMETHOD.

  METHOD is_scalene.
   if is_triangle( side_a = side_a
                       side_b = side_b
                       side_c = side_c ). 
    else.
      raise exception type cx_parameter_invalid.
    endif.    
  "A scalene triangle has all sides of different lengths.
  if is_equilateral( side_a = side_a
                         side_b = side_b
                         side_c = side_c ).
        result = abap_false.
  elseif is_isosceles( side_a = side_a
                         side_b = side_b
                         side_c = side_c ).
        result = abap_false.
  else.
      result = abap_true.
  endif.
  ENDMETHOD.

  METHOD is_triangle.
    if (    side_a + side_b >= side_c
        and side_b + side_c >= side_a
        and side_c + side_a >= side_b )
    and (   side_a > 0
        and side_b > 0
        and side_c > 0 ).
      result = abap_true.
    else.
      result = abap_false.
    endif.
  endmethod.
 


ENDCLASS.
