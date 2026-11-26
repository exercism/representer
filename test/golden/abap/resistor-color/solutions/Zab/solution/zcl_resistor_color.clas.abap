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
   TYPES: BEGIN OF ty_colours,
            name type string,
            value type i,
          END OF ty_colours.


    DATA: ls_value TYPE ty_colours,
          lt_values TYPE STANDARD TABLE OF ty_colours.

    lt_values = VALUE #( ( name = 'black' value = 0 )
                         ( name = 'brown' value = 1 )
                         ( name = 'red' value = 2 )
                         ( name = 'orange' value = 3 )
                         ( name = 'yellow' value = 4 )
                         ( name = 'green' value = 5 )
                         ( name = 'blue' value = 6 )
                         ( name = 'violet' value = 7 )
                         ( name = 'grey' value = 8 )
                         ( name = 'white' value = 9 )
                       ).


     ls_value = lt_values[ name = color_code ].
     value = ls_value-value.
  ENDMETHOD.

ENDCLASS.
