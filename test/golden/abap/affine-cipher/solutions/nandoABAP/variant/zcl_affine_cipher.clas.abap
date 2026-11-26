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
      encode IMPORTING phrase        TYPE string
                       key           TYPE key
             RETURNING VALUE(cipher) TYPE string
             RAISING   cx_parameter_invalid,
      decode IMPORTING cipher        TYPE string
                       key           TYPE key
             RETURNING VALUE(phrase) TYPE string
             RAISING   cx_parameter_invalid,
      check_coprime
             IMPORTING number        TYPE i
             RAISING   cx_parameter_invalid,
      inverse_MMI
             IMPORTING number        TYPE i
             RETURNING VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: i   TYPE i VALUE 0,
          num TYPE i,
          str TYPE string,
          alp TYPE string VALUE 'abcdefghijklmnopqrstuvwxyz'.
ENDCLASS.



CLASS zcl_affine_cipher IMPLEMENTATION.
  METHOD encode.
    "Implement solution

    check_coprime( number = key-a ).
    phrase = TO_LOWER( phrase ).
    REPLACE ALL OCCURRENCES OF REGEX '[^a-z0-9]' IN phrase WITH ''.

    DO STRLEN( phrase ) TIMES.
      str = phrase+i(1).

      FIND REGEX '[0-9]' IN str.
      IF sy-subrc = 0.
        cipher = cipher && str.
      ELSE.
        FIND str IN alp MATCH OFFSET num.
        num = ( key-a * num + key-b ) MOD 26.
        cipher = cipher && alp+num(1).
      ENDIF.

      IF sy-index MOD 5 = 0 AND sy-index <> STRLEN( phrase ).
        cipher = cipher && | |.
      ENDIF.

      i += 1.
    ENDDO.
  ENDMETHOD.

  METHOD decode.
    "Implement solution

    check_coprime( number = key-a ).
    REPLACE ALL OCCURRENCES OF REGEX '[^a-z0-9]' IN cipher WITH ''.

    DO STRLEN( cipher ) TIMES.
      str = cipher+i(1).

      FIND REGEX '[0-9]' IN str.
      IF sy-subrc = 0.
        phrase = phrase && str.
      ELSE.
        FIND str IN alp MATCH OFFSET num.
        num = ( inverse_MMI( number = key-a ) / ( num - key-b ) ) MOD 26.
        phrase = phrase && alp+num(1).
      ENDIF.

      i += 1.
    ENDDO.
  ENDMETHOD.

  METHOD check_coprime.
    IF number MOD 2 = 0 OR number MOD 13 = 0.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
  ENDMETHOD.

  METHOD inverse_MMI.
    DATA n TYPE i.
    WHILE n <> 1.
      result = sy-index.
      n = ( number * result ) MOD 26.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
