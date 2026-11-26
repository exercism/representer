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
    METHODS char_count
      IMPORTING
        text          TYPE string
        char          TYPE string
      RETURNING
        VALUE(result) TYPE i.
ENDCLASS.



CLASS zcl_anagram IMPLEMENTATION.
  METHOD anagram.
    DATA(input_lower) = TO_LOWER( input ).
    DATA(input_strlen) = STRLEN( input_lower ).
    LOOP AT candidates ASSIGNING FIELD-SYMBOL(<candidate>).
      DATA(candidate_lower) = TO_LOWER( <candidate> ).
      " are both the same (checking lowercase versions of both words)
      IF input_lower = candidate_lower.
        CONTINUE.
      ENDIF.
      " check, if the candidate even has the same length as the input
      IF input_strlen <> STRLEN( candidate_lower ).
        CONTINUE.
      ENDIF.
      " going through each letter in the input and checking if the letter's count is the same in the candidate
      DATA(matches) = abap_true.
      DO input_strlen TIMES.
        DATA(char_pos) = sy-index - 1.
        DATA(char) = input+char_pos(1).
        " Checking that both the input and the candidate have the char an equal number of times
        IF char_count( text = input_lower char = char ) <> char_count( text = candidate_lower char = char ).
          matches = abap_false.
          EXIT.
        ENDIF.
      ENDDO.
      IF matches = abap_false.
        CONTINUE.
      ENDIF.
      " candidate is an anagram, so it's added to the result
      APPEND <candidate> TO result.
    ENDLOOP.
  ENDMETHOD.
  
  METHOD char_count.
    DO STRLEN( text ) TIMES.
      DATA(char_pos) = sy-index - 1.
      DATA(char_at_pos) = text+char_pos(1).
      IF char = char_at_pos.
        result = result + 1.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
