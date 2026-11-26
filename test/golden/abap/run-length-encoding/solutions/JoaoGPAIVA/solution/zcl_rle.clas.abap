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
  
    TYPES: BEGIN OF lty_table,
          letra TYPE string,
          rep TYPE i,
    END OF lty_table.
    DATA: lv_length TYPE i,
          lv_pos TYPE i,
          lv_ch TYPE string,
          lt_letras TYPE TABLE OF lty_table,
          ls_letra TYPE lty_table,
          lv_aux TYPE i.
    lv_length = STRLEN( input ).
      
    DO lv_length TIMES.
      lv_pos = sy-index - 1.
      lv_ch = input+lv_pos(1).
      IF lv_ch EQ '1' OR lv_ch EQ '2' OR lv_ch EQ '3' OR lv_ch EQ '4' OR lv_ch EQ '5' OR lv_ch EQ '6' OR               lv_ch EQ '7' OR lv_ch EQ'8' OR lv_ch EQ '9' OR lv_ch EQ '0'.
        RAISE EXCEPTION TYPE cx_parameter_invalid.
      ELSE.
          DESCRIBE TABLE lt_letras LINES lv_aux.
          IF lv_aux > 0.
            ls_letra = lt_letras[ lv_aux ].
            IF ls_letra-letra EQ lv_ch.
              ls_letra-rep = ls_letra-rep + 1.
              lt_letras[ lv_aux ] = ls_letra.
            ELSE.
              ls_letra-letra = lv_ch.
              ls_letra-rep = 1.
              APPEND ls_letra TO lt_letras.
            ENDIF.
          ELSE.
            ls_letra-letra = lv_ch.
            ls_letra-rep = 1.
            APPEND ls_letra TO lt_letras.
          ENDIF.
      ENDIF.
    ENDDO.

    LOOP AT lt_letras INTO ls_letra.
      IF ls_letra-rep > 1.
        result = result && ls_letra-rep && ls_letra-letra.
      ELSE.
        result = result && ls_letra-letra.
      ENDIF.
      
    ENdLOOP.

  ENDMETHOD.


  METHOD decode.

    DATA: lv_aux TYPE string,
          lv_pos TYPE i,
          lv_length TYPE i,
          lv_ch TYPE string,
          lv_cnt TYPE i.

    lv_length = STRLEN( input ).
    DO lv_length TIMES.
        lv_pos = sy-index - 1.
        lv_ch = input+lv_pos(1).
        IF lv_ch EQ '1' OR lv_ch EQ '2' OR lv_ch EQ '3' OR lv_ch EQ '4' OR lv_ch EQ '5' OR lv_ch EQ '6' OR lv_ch EQ '7' OR lv_ch EQ'8' OR lv_ch EQ '9' OR lv_ch EQ '0'.
          lv_aux = lv_aux && lv_ch.
        ELSEIF lv_aux EQ ''.
          result = result && lv_ch.
        ELSEIF lv_aux NE ''.
          lv_cnt = lv_aux.
          DO lv_cnt TIMES.
            result = result && lv_ch.
          ENDDO.
          lv_cnt = 0.
          lv_aux = ''.
        ENDIF.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
