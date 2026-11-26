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
* add solution here
   value = cond #( WHEN to_upper( color_Code ) eq `BLACK` THEN 0
                   WHEN to_upper( color_code ) eq `BROWN` THEN 1
                   WHEN to_upper( color_code ) eq `RED` THEN  2
                   WHEN to_upper( color_code ) eq `ORANGE` THEN 3
                   WHEN to_upper( color_code ) eq `YELLOW` THEN 4
                   WHEN to_upper( color_code ) eq `GREEN` THEN 5
                   WHEN to_upper( color_code ) eq `BLUE` THEN 6
                   WHEN to_upper( color_code ) eq `VIOLET` THEN 7
                   WHEN to_upper( color_code ) eq `GREY` THEN 8
                   WHEN to_upper( color_code ) eq `WHITE` THEN 9 ).
  ENDMETHOD.

ENDCLASS.
