CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text TYPE string
      RETURNING
        VALUE(plain_text)  TYPE string .
    METHODS encode
      IMPORTING
        plain_text        TYPE string
      RETURNING
        VALUE(cipher_text) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD decode.
* todo
  plain_text = replace(
        val = encode( cipher_text)
      sub  = ` `
      with = ``
        occ = 0 
    ).
  ENDMETHOD.

  METHOD encode.
* todo
  constants c_text TYPE string VALUE 'abcdefghijklmnopqrstuvwxyz'.
    data(v_text) = replace( val = to_lower( plain_text) 
                          regex = `[ .,]`
                          with  = ``
                            occ = 0 ).
    Data(v_iteration) = 0.
    while v_iteration < strlen( v_text ).
          data(v_position) = 25 - find( val = c_text  sub = v_text+v_iteration(1) ).
              if v_position between 0 and 25.
                          cipher_text = cipher_text && substring( val = c_text
                                                off = v_position
                                                len = 1 ).
              else.
                cipher_text = cipher_text && v_text+v_iteration(1).
          endif.
          v_iteration = v_iteration + 1.
          if v_iteration mod 5 = 0 and v_iteration < strlen( v_text ).
          cipher_text = cipher_text && ` `.
        endif.
  endwhile.
  ENDMETHOD.
ENDCLASS.
