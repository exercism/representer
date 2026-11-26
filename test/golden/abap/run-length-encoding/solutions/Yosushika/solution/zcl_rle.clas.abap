CLASS zcl_rle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS encode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.

    METHODS decode IMPORTING input         TYPE string
                   RETURNING VALUE(result) TYPE string.
  PRIVATE SECTION.
    DATA : count  TYPE i,
           letter TYPE string.
ENDCLASS.


CLASS zcl_rle IMPLEMENTATION.

  METHOD encode.
    DATA index TYPE i.

    IF input CA '0123456789' OR input IS INITIAL.
      RETURN.
    ENDIF.

    WHILE index <= strlen( input ).
      IF index NE 0 AND letter NE input+index(1).
        result = COND #( WHEN count = 1 THEN |{ result }{ letter }| ELSE |{ result }{ count }{ letter }| ).
        CLEAR count.
      ENDIF.
      
      letter = |{ input+index(1) }|. 
      count += 1.
      index += 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD decode.
    DATA index TYPE i.

    CLEAR count.
    WHILE index <= strlen( input ).
      IF input+index(1) CA '0123456789'.
        count = |{ count }{ input+index(1) }|.
      ELSE.
        count = COND #( WHEN count = 0 THEN 1 ELSE count ).
        result = |{ result }{ repeat( val = input+index(1) occ = count ) }|.
        CLEAR count.
      ENDIF.
      index += 1.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
