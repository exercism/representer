CLASS zcl_anagram DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS anagram
      IMPORTING
        input         TYPE string
        candidates    TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: t_char type c length 1.
    TYPES: tt_chars TYPE STANDARD TABLE OF t_char WITH EMPTY KEY.
    METHODS get_chartable
      IMPORTING
                !input          TYPE string
      RETURNING VALUE(r_result) TYPE tt_chars.


ENDCLASS.



CLASS zcl_anagram IMPLEMENTATION.
  METHOD anagram.
* add solution here
    DATA(in_tab) = get_chartable( input ).
    result = REDUCE #( INIT r = VALUE string_table(  )
                       FOR wa IN candidates
                       NEXT
                       r = COND #( WHEN ( to_upper( wa ) ne to_upper( input ) and in_tab EQ get_chartable( wa ) )
                                   THEN VALUE #( BASE r ( wa ) )
                                   ELSE r
                                 )
                       ).
  ENDMETHOD.
  METHOD get_chartable.
    r_result = VALUE #( FOR i = 0 THEN i + 1 UNTIL i = strlen( input ) ( CONV t_char( to_upper( input+i(1) ) ) ) ).
    SORT r_result BY table_line.
  ENDMETHOD.

ENDCLASS.