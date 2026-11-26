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
    DATA l_candidates LIKE candidates.
    l_candidates = candidates.

    DATA l2_candidates LIKE candidates.
    l2_candidates = candidates.

    DATA(not_anagram) = 0.
    DATA(l_input) = input.
    TRANSLATE l_input TO LOWER CASE.
    LOOP AT l_candidates ASSIGNING FIELD-SYMBOL(<fs_candidate>).
      TRANSLATE <fs_candidate> TO LOWER CASE.
      not_anagram += 1.
      DATA(counter) = 0.
      DO strlen( l_input ) TIMES.
        REPLACE FIRST OCCURRENCE OF l_input+counter(1) IN <fs_candidate> WITH ''.
        counter += 1.
      ENDDO.
      IF <fs_candidate> IS NOT INITIAL.
*        delete not_anagram from candidates.
        DELETE l2_candidates INDEX not_anagram.
        not_anagram -= 1.
      ENDIF.
    ENDLOOP.
    LOOP AT l2_candidates INTO DATA(wa_candidates).
      TRANSLATE wa_candidates TO LOWER CASE.
      IF strlen( wa_candidates ) <> strlen( input ) OR
            wa_candidates = l_input.
        DELETE l2_candidates INDEX sy-tabix.
      ENDIF.
    ENDLOOP.
    result = l2_candidates.  
ENDMETHOD.
ENDCLASS.
