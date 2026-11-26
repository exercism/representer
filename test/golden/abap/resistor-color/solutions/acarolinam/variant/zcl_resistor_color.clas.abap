CLASS zcl_resistor_color DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS resistor_color
      IMPORTING
        color_code   TYPE string
      RETURNING
        VALUE(value) TYPE i.
ENDCLASS.

CLASS zcl_resistor_color IMPLEMENTATION.

  METHOD resistor_color.
    value = COND #( WHEN color_code EQ 'black' THEN 1
                    WHEN color_code EQ 'white' THEN 9 
                    WHEN color_code EQ 'orange' THEN 3 ).
  ENDMETHOD.

ENDCLASS.
