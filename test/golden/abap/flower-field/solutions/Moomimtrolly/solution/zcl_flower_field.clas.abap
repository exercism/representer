CLASS zcl_flower_field DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS annotate
        IMPORTING
          !input        TYPE string_table
        RETURNING
          VALUE(result) TYPE string_table.

ENDCLASS.

CLASS zcl_flower_field IMPLEMENTATION.

  METHOD annotate.
    DATA:
     lv_num(1) TYPE n.
    result = input.
    LOOP AT result ASSIGNING FIELD-SYMBOL(<lv_row>).
      DO STRLEN( <lv_row> ) TIMES.
        CHECK substring( val = <lv_row> off = sy-index - 1 len = 1 ) = '*'.
        DATA(lv_col) = sy-index.
        DO 3 TIMES.
          DATA(lv_row_off) = sy-index - 2.
          DO 3 TIMES.
            DATA(lv_col_off) = sy-index - 2.
            CHECK lv_row_off <> 0
               OR lv_col_off <> 0. "Not Itself
            CHECK sy-tabix + lv_row_off > 0 "Row Exists Above
              AND sy-tabix + lv_row_off <= LINES( input ). "Row Exists Below
            CHECK lv_col + lv_col_off > 0 "Column Exists Left
              AND lv_col + lv_col_off <= STRLEN( <lv_row> ).  "Column Exists Right
            CHECK substring( val = result[ ( sy-tabix + lv_row_off ) ] off = ( lv_col + lv_col_off - 1 ) len = 1 ) <> '*'. "Not a flower
            lv_num = substring( val = result[ ( sy-tabix + lv_row_off ) ] off = ( lv_col + lv_col_off - 1 ) len = 1 ).
            lv_num += 1.
            result[ ( sy-tabix + lv_row_off ) ] = replace( val = result[ ( sy-tabix + lv_row_off ) ] off = ( lv_col + lv_col_off - 1 ) len = 1 WITH = lv_num ).
          ENDDO.
        ENDDO.
      ENDDO.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
