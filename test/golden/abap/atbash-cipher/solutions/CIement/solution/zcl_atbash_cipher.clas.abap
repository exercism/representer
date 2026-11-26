CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:

      constructor,

      decode
        IMPORTING
          cipher_text       TYPE string
        RETURNING
          VALUE(plain_text) TYPE string,

      encode
        IMPORTING
          plain_text         TYPE string
        RETURNING
          VALUE(cipher_text) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: alphabet TYPE string_table.

ENDCLASS.


CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD constructor.

    alphabet = VALUE #(
        ( |a| ) ( |b| ) ( |c| ) ( |d| )
        ( |e| ) ( |f| ) ( |g| ) ( |h| )
        ( |i| ) ( |j| ) ( |k| ) ( |l| )
        ( |m| ) ( |n| ) ( |o| ) ( |p| )
        ( |q| ) ( |r| ) ( |s| ) ( |t| )
        ( |u| ) ( |v| ) ( |w| ) ( |x| )
        ( |y| ) ( |z| )
    ).
  ENDMETHOD.

  METHOD decode.
    DATA(index) = 0.

    WHILE index < strlen( cipher_text ).
      DATA(char) = |{ cipher_text+index(1) case = lower }|.

      if char >= 'a' and char <= 'z'.
        data(i) = lines( alphabet ) - line_index( alphabet[ table_line = char ] ) + 1.
        char = alphabet[ i ].
        console=>log( char ).
        plain_text = |{ plain_text }{ char }|.
      elseif char >= 0 and char <= 9.
        plain_text = |{ plain_text }{ char }|.
      ENDIF.

      index += 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD encode.
    DATA(index) = 0.
    data(grp) = 0.

    WHILE index < strlen( plain_text ).
      DATA(char) = to_lower( |{ plain_text+index(1) }| ).
      data(new_char) = ||.

      if char >= 'a' and char <= 'z'.
        data(i) = lines( alphabet ) - line_index( alphabet[ table_line = char ] ) + 1.
        new_char = alphabet[ i ].
      elseif char >= 0 and char <= 9.
        new_char = char.
      ENDIF.

      if new_char is not initial.
        if grp mod 5 = 0 and grp > 0.
          cipher_text = |{ cipher_text } |.
          grp = 0.
        endif.
        cipher_text = |{ cipher_text }{ new_char }|.
        grp += 1.
      endif.

      index += 1.
    ENDWHILE.
  

ENDMETHOD.
ENDCLASS.