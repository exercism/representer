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

    data(lv_length) = strlen( input ).
    data : lv_char type i,
           lv_count type i value 1.

    do lv_length times.
      lv_char = sy-index - 1.
      if input+sy-index(1) EQ input+lv_char(1).
        ADD 1 to lv_count. "lv_count ++
      else.
      
      result = |{ result }{ COND #( when lv_count = 1 THEN |{ input+lv_char(1) }| ELSE |{ lv_count }{ input+lv_char(1) }| ) }|.
      lv_count = 1.
      endif.
    enddo.

  ENDMETHOD.


  METHOD decode.
    DATA current TYPE string.
    DATA: numstr TYPE string,
         lv_all_char TYPE string,
         lv_all_char2 TYPE string.

    DATA count TYPE i.
    DATA i TYPE i.
    lv_all_char2 = sy-abcde.
    TRANSLATE lv_all_char2 to LOWER CASE.
    lv_all_char = | { sy-abcde }{ lv_all_char2 }|.

    DO strlen( input ) TIMES.
      i = sy-index - 1.
      current = input+i(1).
    
      IF current CO lv_all_char .
    
        count = SWITCH #( numstr WHEN '' THEN 1 ELSE CONV i( numstr ) ).
        result = |{ result }{ repeat( val = current occ = count ) }|.
        numstr = ''.
      ELSE.
        numstr = |{ numstr }{ current }|.
      ENDIF.
      i = i + 1.
    ENDDO.

  ENDMETHOD.

ENDCLASS.