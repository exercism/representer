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
          CLASS-METHODS class_constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.

       CLASS-DATA _mt_primes TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
    METHODS _get_prime
      IMPORTING
        id_count        TYPE i
      RETURNING
        VALUE(rd_prime) TYPE i.
    METHODS _calculate_prime
      IMPORTING
        id_count TYPE i.
    METHODS _is_prime
      IMPORTING
        id_number       TYPE i
      RETURNING
        VALUE(rf_prime) TYPE abap_bool.
ENDCLASS.


CLASS zcl_nth_prime IMPLEMENTATION.

  METHOD class_constructor.
    _mt_primes = VALUE #( ( 2 )
                          ( 3 )
                          ( 5 )
                          ( 7 )
                          ( 11 )
                          ( 13 )
                          ( 17 )
                          ( 19 ) ).
  ENDMETHOD.
  METHOD prime.
    result = COND #( WHEN ( input GE 1 )
                     THEN _get_prime( input )
                     ELSE THROW cx_parameter_invalid(  ) ).
  ENDMETHOD.


  METHOD _get_prime.
    _calculate_prime( id_count ).
    rd_prime = _mt_primes[ id_count ].
  ENDMETHOD.


  METHOD _calculate_prime.
    WHILE ( lines( _mt_primes ) LT id_count ).

      DATA(ld_max) = _mt_primes[ lines( _mt_primes ) ] - 1.

      WHILE ( _is_prime( ld_max ) EQ abap_false ).

        ld_max += 1.

      ENDWHILE.
      INSERT ld_max INTO TABLE _mt_primes.

    ENDWHILE.
  ENDMETHOD.


  METHOD _is_prime.
    DATA(ld_i) = 2.

    rf_prime = abap_true.
    WHILE ( ld_i * ld_i LE id_number ).

      IF ( id_number MOD ld_i EQ 0 ).

        rf_prime = abap_false.
        EXIT.

      ELSE.

        ld_i += 1.

      ENDIF.

    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
