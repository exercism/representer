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
  types : begin of str_letters ,
         letter(1),
        END OF str_letters .
ENDCLASS.

CLASS zcl_anagram IMPLEMENTATION.
  METHOD anagram.
* add solution here

DATA:
      input_chars     TYPE SORTED TABLE OF c WITH NON-UNIQUE KEY table_line,
      candidate_chars TYPE SORTED TABLE OF c WITH NON-UNIQUE KEY table_line,
      lv_input          TYPE string,
      lv_candidate      TYPE string,
      lv_index             TYPE i ,
      lv_ch(1) .

    lv_input = to_lower( input ).
    data(lv_len) = strlen( input ).
    WHILE lv_index < lv_len.
      lv_ch = lv_input+lv_index(1).
      INSERT lv_ch INTO TABLE input_chars.
      lv_index += 1.
    ENDWHILE.
    LOOP AT candidates ASSIGNING FIELD-SYMBOL(<fs>).
      lv_candidate = to_lower( <fs> ).
      lv_index = 0.
      lv_len = strlen( <fs> ).
      CLEAR candidate_chars.
      WHILE lv_index < lv_len.
        lv_ch = lv_candidate+lv_index(1).
        INSERT lv_ch INTO TABLE candidate_chars.
        lv_index += 1.
      ENDWHILE.

      IF input_chars = candidate_chars AND lv_input <> lv_candidate.
        APPEND <fs> TO result.
      ENDIF.
    ENDLOOP.

"" another solution 
*data : lt_letters1 type table of str_letters , ls_letters1 TYPE str_letters .
*data : lt_letters2 type table of str_letters , ls_letters2 TYPE str_letters .
*data tmp_result type string_table .

*loop at candidates into data(candidate) .
*data(isAnagram) =   'X' .
*data(len1)  = strlen( input ).
*data(len2)  = strlen( candidate ).
*data(temp_candidate) = candidate .

*if ( len1 ne len2  ) .
*    isAnagram = '' .
* else .

*translate input TO LOWER CASE .
*translate temp_candidate TO LOWER CASE .

*data(idx) = 0 .
*while idx < len1 .

*   data(letter)  = input+idx(1) .
*   data(letter2) = temp_candidate+idx(1) .

*   ls_letters1-letter = letter .
*   APPEND ls_letters1 to lt_letters1 .
*   ls_letters2-letter = letter2 .
*   APPEND ls_letters2 to lt_letters2 .

*   idx = idx + 1 .
*ENDWHILE .

*sort lt_letters1 by letter .
*sort lt_letters2 by letter .

*loop at lt_letters1 into ls_letters1 .
*   if ( ls_letters1-letter ne lt_letters2[ sy-tabix ] ) .
*       isanagram = '' .
*       exit .
*     ENDIF .
*  ENDLOOP .

*if isAnagram = 'X' .
*   append candidate to result .
*endif .
*endif .

*free  : lt_letters1 , lt_letters2 .
*clear : ls_letters1 , ls_letters2 .
*ENDLOOP .

ENDMETHOD.

ENDCLASS.