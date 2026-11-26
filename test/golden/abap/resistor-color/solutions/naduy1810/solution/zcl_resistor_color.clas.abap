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
    TYPES:
      BEGIN OF lty_color_code,
        color TYPE string,
        code  TYPE i,
      END OF lty_color_code,
      ltt_color_code TYPE STANDARD TABLE OF lty_color_code.

     DATA(lt_color_code) = VALUE ltt_color_code( 
                        ( color = 'blank'   code = 0 )
                        ( color = 'brown'   code = 1 )
                        ( color = 'red'     code = 2 )
                        ( color = 'orange'  code = 3 )
                        ( color = 'yellow'  code = 4 )
                        ( color = 'green'   code = 5 )
                        ( color = 'blue'    code = 6 )
                        ( color = 'violet'  code = 7 )
                        ( color = 'grey'    code = 8 )
                        ( color = 'white'   code = 9 ) ).

    READ TABLE lt_color_code INTO DATA(ls_color_code)
      WITH KEY color = color_code.
    IF sy-subrc = 0.
      value = ls_color_code-code.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
