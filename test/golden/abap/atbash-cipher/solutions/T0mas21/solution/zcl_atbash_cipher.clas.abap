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
      DATA: plain_str TYPE string VALUE 'abcdefghijklmnopqrstuvwxyz1234567890',
            code_str TYPE string VALUE  'zyxwvutsrqponmlkjihgfedcba1234567890',
            i TYPE i VALUE 0.
     WHILE i < strlen( cipher_text ).
      DATA(letter) = cipher_text+i(1).
        DATA(index) = sy-fdpos.
        FIND letter IN plain_str MATCH OFFSET index.
        IF sy-subrc = 0.
          plain_text = plain_text && code_str+index(1).
        ELSE.
          "plain_text = plain_text && letter.
        ENDIF.
      i = i + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD encode.
    DATA: plain_str TYPE string VALUE 'abcdefghijklmnopqrstuvwxyz1234567890',
          code_str TYPE string VALUE  'zyxwvutsrqponmlkjihgfedcba1234567890 ',
          i TYPE i VALUE 0,
          space TYPE i VALUE 0.
      WHILE i < strlen( plain_text ).
        DATA(letter) = to_lower( plain_text+i(1) ).
        DATA(index) = sy-fdpos.
        FIND letter IN plain_str MATCH OFFSET index.
        IF sy-subrc = 0.
          IF space MOD 5 EQ 0 AND i <> 0.
            cipher_text = cipher_text && code_str+36(1) && code_str+index(1).
          ELSE.
            cipher_text = cipher_text && code_str+index(1).
          ENDIF.
          space = space + 1.
        ELSE.
          "plain_text = plain_text && letter.
        ENDIF.
        i = i + 1.
      ENDWHILE.
  ENDMETHOD.
ENDCLASS.
