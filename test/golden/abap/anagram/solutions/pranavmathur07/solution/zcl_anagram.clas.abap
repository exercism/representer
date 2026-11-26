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
ENDCLASS.



CLASS zcl_anagram IMPLEMENTATION.
  METHOD anagram.
* add solution here

    input = to_lower( input ).
    DATA(len) = strlen( input ).
    LOOP AT candidates INTO DATA(candidate_w).
      DATA(input2) = input.
      DATA(word) = to_lower( candidate_w ).
      IF len = strlen( candidate_w ) AND input <> word.
        DO len times.
          IF input2(1) CA word.
              REPLACE input2(1) IN word with ``.
          ENDIF.
          SHIFT input2.
        ENDDO. 
      IF word = ''.
        APPEND candidate_w TO result.
      ENDIF.
      ENDIF.
      
      
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
