CLASS zcl_reverse_string DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS reverse_string
      IMPORTING
        input         TYPE string
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_reverse_string IMPLEMENTATION.

  METHOD reverse_string.
    " Please complete the implementation of the reverse_string method
    DATA  lenstr  TYPE i.
    DATA  posini  TYPE i.
    DATA  posfin TYPE i.
    DATA  cont  TYPE i.
    DATA  aux   TYPE string.
    DATA  auxc1(30)  TYPE c.
    DATA  auxc2(30)  TYPE c.
    DATA  chr  TYPE c.
    DATA  csep TYPE c VALUE 'N'.
    lenstr = strlen( input ).
    DO lenstr TIMES.
      cont = cont + 1.
      posini = lenstr - cont.
      posfin = posini + 1.
      chr = substring( val = input off = posini len = 1 ).
      IF chr = ''.
        chr = '*'.
        csep = 'S'.
      ENDIF.
      aux = aux && chr.
    ENDDO.
    IF csep = 'S'.
      SPLIT aux AT '*' INTO auxc1 auxc2.
      CONCATENATE auxc1 auxc2 INTO aux SEPARATED BY space.
    ENDIF.
    result = aux.
  ENDMETHOD.

ENDCLASS.
