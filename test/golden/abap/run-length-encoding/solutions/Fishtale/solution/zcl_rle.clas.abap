CLASS zcl_rle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS encode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

    METHODS decode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

ENDCLASS.


CLASS zcl_rle IMPLEMENTATION.

  METHOD encode.
    result = cond #( when strlen( input ) <= 1
                     then input
                     else reduce #( init encoded_string type string
                                         char1 type string
                                         char2 = substring( val = input len = 1 off = 0 )
                                         char_counter type p
                                    for  offset = 0 until offset > strlen( input )
                                    next char1 = char2
                                         char2 = cond #( when offset < strlen( input ) then substring( val = input len = 1 off = offset ) else '' )
                                         encoded_string = cond #( when char1 = char2
                                                                  then encoded_string
                                                                  else |{ encoded_string }{ cond #( when char_counter = 1 then '' else char_counter ) }{ char1 }| )
                                         char_counter = cond #( when char1 = char2 then char_counter + 1 else 1 ) ) ).
  ENDMETHOD.


  METHOD decode.
    DATA: number TYPE i.
    DO strlen( input ) TIMES.
      data(character) = substring( val = input len = 1 off = ( sy-index - 1 ) ).
      IF character CO '0123456789'.
        number = number * 10 + character.
      ELSE.
        DO cond #( when number = 0 then 1 else number ) TIMES.
          result = |{ result }{ character }|.
        ENDDO.
        CLEAR: number.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
