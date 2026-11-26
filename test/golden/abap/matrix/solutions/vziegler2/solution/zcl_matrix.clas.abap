CLASS zcl_matrix DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS matrix_row
      IMPORTING
        string        TYPE string
        index         TYPE i
      RETURNING
        VALUE(result) TYPE integertab.
    METHODS matrix_column
      IMPORTING
        string        TYPE string
        index         TYPE i
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_matrix IMPLEMENTATION.
  METHOD matrix_row.
    SPLIT string AT `\n` INTO TABLE DATA(lt_string).
    SPLIT lt_string[ index ] AT space INTO TABLE DATA(lt_row).
    result = CONV #( lt_row ).
  ENDMETHOD.
  METHOD matrix_column.
    SPLIT string AT `\n` INTO TABLE DATA(lt_string).
    LOOP AT lt_string INTO DATA(lv_string).
      SPLIT lv_string AT space INTO TABLE DATA(lt_row).
      APPEND lt_row[ index ] TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
