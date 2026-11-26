CLASS zcl_word_count DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF return_structure,
        word  TYPE string,
        count TYPE i,
      END OF return_structure,
      return_table TYPE STANDARD TABLE OF return_structure WITH KEY word.
    METHODS count_words
      IMPORTING
        !phrase       TYPE string
      RETURNING
        VALUE(result) TYPE return_table .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_word_count IMPLEMENTATION.

  METHOD count_words.
    DATA lt_string TYPE string_table.
    DATA lt_string_single TYPE string_table.
    DATA lv_count TYPE i.
    TRANSLATE phrase TO lower case.
    REPLACE ALL OCCURRENCES OF ',' in phrase WITH ` `.
    REPLACE ALL OCCURRENCES OF ':' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '!' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '&' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '@' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '^' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '%' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '$' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '.' in phrase WITH ''.
    REPLACE ALL OCCURRENCES OF '\n' in phrase WITH ` `.
    replace all occurrences of `'` in phrate with ``.
    CONDENSE phrase.

    SPLIT phrase AT ' ' INTO table lt_string.
    lt_string_single = lt_string.
    SORT lt_string_single.
    DELETE ADJACENT DUPLICATES FROM lt_string_single.

    LOOP AT lt_string_single into DATA(ls_word).
        lv_count = 0.
        LOOP AT lt_string into DATA(compare_word).
            IF compare_word = ls_word.
              lv_count += 1.
            ENDIF.
        ENDLOOP.
        APPEND VALUE #( count = lv_count
                        word = ls_word
        ) TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
