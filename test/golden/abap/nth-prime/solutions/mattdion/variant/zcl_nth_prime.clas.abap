CLASS zcl_nth_prime DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS prime
      IMPORTING
        input         TYPE i
      RETURNING
        VALUE(result) TYPE i
      RAISING
        cx_parameter_invalid.
  PROTECTED SECTION.
    METHODS is_number_prime
      IMPORTING iv_number TYPE i
      RETURNING VALUE(rv_is_prime) TYPE c.
    
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_nth_prime IMPLEMENTATION.
  METHOD prime.
    DATA: lv_nth_prime TYPE i.

    IF input = 0.
      RAISE EXCEPTION NEW cx_parameter_invalid( ).
    ENDIF.

    WHILE lv_nth_prime < input.
      ADD 1 TO result.
      IF is_number_prime( result ) = abap_true.
        ADD 1 to lv_nth_prime.
      ENDIF.
    ENDWHILE.

  ENDMETHOD.

  METHOD is_number_prime.

    CASE iv_number.
      WHEN 1.
        rv_is_prime = abap_false.
      WHEN 2.
        rv_is_prime = abap_true.
      WHEN OTHERS.
        IF iv_number MOD 2 = 0.
          " even number
          rv_is_prime = abap_false.
        ELSE.
          rv_is_prime = abap_true.
          DATA(lv_check) = abap_false.
          " odd number
          DO iv_number - 2 TIMES.
            DATA(lv_index) = sy-index.
            IF lv_check = abap_false.
              lv_check = abap_true.
            ELSE.
              lv_check = abap_false.
              DATA(lv_mod) = iv_number + lv_index.              
              IF iv_number MOD lv_mod = 0.
                rv_is_prime = abap_false.
                EXIT.
              ENDIF.
            ENDIF.
          ENDDO.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
