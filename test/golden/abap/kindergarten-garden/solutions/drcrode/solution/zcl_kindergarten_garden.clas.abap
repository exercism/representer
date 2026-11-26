CLASS zcl_kindergarten_garden DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS plants
      IMPORTING
        diagram        TYPE string
        student        TYPE string
      RETURNING
        VALUE(results) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA students TYPE string_table.

ENDCLASS.


CLASS zcl_kindergarten_garden IMPLEMENTATION.
  METHOD plants.
    students = VALUE string_table(
    ( |Alice| )  ( |Bob| )    ( |Charlie| ) ( |David| )
    ( |Eve| )    ( |Fred| )   ( |Ginny| )   ( |Harriet| )
    ( |Ileana| ) ( |Joseph| ) ( |Kincaid| ) ( |Larry| ) ).

    DATA(pos1) = ( line_index( students[ table_line = student ] ) - 1 ) * 2.
    IF diagram CS '\n'.
      DATA(pos2) = sy-fdpos + pos1 + 2.
    ENDIF.

    results = VALUE string_table(
    FOR a = pos1 UNTIL a = pos1 + 2
    ( SWITCH string( substring( val = diagram off = a len = 1 )
        WHEN 'G' THEN 'grass'
        WHEN 'C' THEN 'clover'
        WHEN 'R' THEN 'radishes'
        WHEN 'V' THEN 'violets' ) ) ).
    results = VALUE string_table( BASE results
    FOR b = pos2 UNTIL b = pos2 + 2
    ( SWITCH string( substring( val = diagram off = b len = 1 )
        WHEN 'G' THEN 'grass'
        WHEN 'C' THEN 'clover'
        WHEN 'R' THEN 'radishes'
        WHEN 'V' THEN 'violets' ) ) ).
  ENDMETHOD.
ENDCLASS.
