CLASS zcl_secret_handshake DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_commands
      IMPORTING code            TYPE i
      RETURNING VALUE(commands) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_secret_handshake IMPLEMENTATION.

  METHOD get_commands.
    DATA: lt_code          TYPE string_table,
          lt_commands_rev  TYPE string_table,
          action           TYPE string.
    
    APPEND 'wink' TO lt_code.
    APPEND 'double blink' TO lt_code.
    APPEND 'close your eyes' TO lt_code.
    APPEND 'jump' TO lt_code.
    APPEND 'reverse ' TO lt_code.
    
    WHILE code > 0.
      IF code MOD 2 = 1.
        READ TABLE lt_code INDEX sy-index INTO action.
        IF action = 'reverse'.
          DATA(lv_idx) = lines( commands ).
          DO lv_idx TIMES.
            APPEND commands[ lv_idx ] TO lt_commands_rev.
            lv_idx = lv_idx + 1.
          ENDDO.
          commands = lt_commands_rev.
        ELSE.
          INSERT action INTO TABLE commands.
        ENDIF.
        CLEAR: action.
      ENDIF.
      code = code DIV 2.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
