CLASS zcl_affine_cipher DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF key,
             a TYPE i,
             b TYPE i,
           END OF key.

    METHODS:
      constructor,
      encode IMPORTING phrase        TYPE string
                       key           TYPE key
             RETURNING VALUE(cipher) TYPE string
             RAISING   cx_parameter_invalid,
      decode IMPORTING cipher        TYPE string
                       key           TYPE key
             RETURNING VALUE(phrase) TYPE string
             RAISING   cx_parameter_invalid.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS co_letters_in_roman_alphabet TYPE i VALUE 26.

    TYPES: BEGIN OF ty_letter_index,
             index  TYPE i,
             letter TYPE c LENGTH 1,
           END OF ty_letter_index.
    TYPES tt_letter_index TYPE SORTED TABLE OF ty_letter_index WITH UNIQUE KEY index.

    DATA alphabet TYPE tt_letter_index.

    METHODS _is_co_prime
      IMPORTING !key          TYPE zcl_affine_cipher=>key
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS _is_positive
      IMPORTING !key          TYPE zcl_affine_cipher=>key
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS _pre_process_text
      IMPORTING iv_text          TYPE string
      RETURNING VALUE(rv_result) TYPE string.

    METHODS _ignore_dots_and_commas
      IMPORTING iv_text          TYPE string
      RETURNING VALUE(rv_result) TYPE string.

    METHODS _mod_mult_inverse
      IMPORTING !key          TYPE zcl_affine_cipher=>key
      RETURNING VALUE(result) TYPE i.
ENDCLASS.



CLASS zcl_affine_cipher IMPLEMENTATION.
  METHOD constructor.
    alphabet = VALUE #( ( index = 0 letter = `a` )
                        ( index = 1 letter = `b` )
                        ( index = 2 letter = `c` )
                        ( index = 3 letter = `d` )
                        ( index = 4 letter = `e` )
                        ( index = 5 letter = `f` )
                        ( index = 6 letter = `g` )
                        ( index = 7 letter = `h` )
                        ( index = 8 letter = `i` )
                        ( index = 9 letter = `j` )
                        ( index = 10 letter = `k` )
                        ( index = 11 letter = `l` )
                        ( index = 12 letter = `m` )
                        ( index = 13 letter = `n` )
                        ( index = 14 letter = `o` )
                        ( index = 15 letter = `p` )
                        ( index = 16 letter = `q` )
                        ( index = 17 letter = `r` )
                        ( index = 18 letter = `s` )
                        ( index = 19 letter = `t` )
                        ( index = 20 letter = `u` )
                        ( index = 21 letter = `v` )
                        ( index = 22 letter = `w` )
                        ( index = 23 letter = `x` )
                        ( index = 24 letter = `y` )
                        ( index = 25 letter = `z` ) ).
  ENDMETHOD.

  METHOD encode.
    IF NOT _is_positive( key ) OR NOT _is_co_prime( key ).
      RAISE EXCEPTION NEW cx_parameter_invalid( ).
    ENDIF.

    DATA(pre_processed_phrase) = _pre_process_text( phrase ).

    DATA(offset) = 0.
    WHILE offset < strlen( pre_processed_phrase ).

      DATA(letter) = pre_processed_phrase+offset(1).

      IF line_exists( alphabet[ letter = letter ] ).
        DATA(encoded_index) = ( key-a * alphabet[ letter = letter ]-index + key-b ) MOD co_letters_in_roman_alphabet.
        DATA(encoded_letter) = alphabet[ index = encoded_index ]-letter.
      ELSE.
        encoded_letter = letter.
      ENDIF.

      cipher = cipher && encoded_letter.

      offset += 1.

      IF offset MOD 5 = 0 AND offset < strlen( pre_processed_phrase ).
        cipher = |{ cipher } |.
      ENDIF.

    ENDWHILE.
  ENDMETHOD.

  METHOD _is_co_prime.
    result = abap_true.

    DATA(min) = nmin( val1 = key-a
                      val2 = co_letters_in_roman_alphabet ).

    DATA(idx) = min.
    WHILE idx > 1.
      IF (     key-a MOD idx = 0
           AND co_letters_in_roman_alphabet MOD idx = 0 ).

        result = abap_false.
        RETURN.
      ENDIF.
      idx -= 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD _is_positive.
    result = COND #( WHEN key-a > 0 AND key-b > 0
                     THEN abap_true
                     ELSE abap_false ).
  ENDMETHOD.

  METHOD _pre_process_text.
    rv_result = to_lower( iv_text ).
    CONDENSE rv_result NO-GAPS.
    rv_result = _ignore_dots_and_commas( rv_result ).
  ENDMETHOD.

  METHOD _ignore_dots_and_commas.
    rv_result = iv_text.
    REPLACE ALL OCCURRENCES OF '.' IN rv_result WITH ''.
    REPLACE ALL OCCURRENCES OF ',' IN rv_result WITH ''.
  ENDMETHOD.

  METHOD decode.
    IF NOT _is_positive( key ) OR NOT _is_co_prime( key ).
      RAISE EXCEPTION NEW cx_parameter_invalid( ).
    ENDIF.

    DATA(mod_mult_inverse) = _mod_mult_inverse( key ).

    DATA(pre_processed_cipher) = _pre_process_text( cipher ).

    DATA(offset) = 0.
    WHILE offset < strlen( pre_processed_cipher ).

      DATA(letter) = pre_processed_cipher+offset(1).

      IF line_exists( alphabet[ letter = letter ] ).
        DATA(decoded_index) = ( mod_mult_inverse * ( alphabet[ letter = letter ]-index - key-b ) ) MOD co_letters_in_roman_alphabet.
        DATA(decoded_letter) = alphabet[ index = decoded_index ]-letter.
      ELSE.
        decoded_letter = letter.
      ENDIF.

      phrase = phrase && decoded_letter.

      offset += 1.

    ENDWHILE.
  ENDMETHOD.

  METHOD _mod_mult_inverse.
    DATA(factor) = 1.

    WHILE ( ( ( key-a * factor ) MOD co_letters_in_roman_alphabet ) <> 1 ).
      factor += 1.
    ENDWHILE.

    result = factor.
  ENDMETHOD.
ENDCLASS.
