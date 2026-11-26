CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS annotate
        IMPORTING
          !input        TYPE string_table
        RETURNING
          VALUE(result) TYPE string_table.
ENDCLASS.
CLASS zcl_minesweeper IMPLEMENTATION.
  METHOD annotate.
    result = input[].
    loop at input into data(lv_row).
      data(lv_rowindex) = sy-tabix.
      data(lv_width) = strlen( lv_row ).
      
      data(lv_colindex) = 0.
      do lv_width times.
        data(lv_char) = lv_row+lv_colindex(1).
        if lv_char = '*'.
          data(row_to_update) = lv_rowindex - 1.
          do 3 times.
            if row_to_update > 0 and row_to_update <= lines( result ).
              ASSIGN result[ row_to_update ] TO field-symbol(<fs>).
              data(col_to_update) = lv_colindex - 1.
              do 3 times.
                if col_to_update > -1 and col_to_update < lv_width.
                  data(lv_char_to_update) = <fs>+col_to_update(1).
                  if lv_char_to_update <> '*'.
                    if lv_char_to_update = ` `.
                      lv_char_to_update = '1'.
                    else.
                      DATA cnt TYPE I.
                      write lv_char_to_update to cnt.
                      cnt += 1.
                      write cnt to lv_char_to_update.
                    endif.
                    <fs> = substring( val = <fs> off = 0 len = col_to_update ) &&
                      lv_char_to_update &&
                      substring( val = <fs> off = col_to_update + 1 ).
                  endif.
                endif.
                col_to_update += 1.
              enddo.
            endif.
            row_to_update += 1.
          enddo.
        endif.
        
        lv_colindex += 1.
      enddo.
    endloop.
  ENDMETHOD.
ENDCLASS.

