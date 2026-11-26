CLASS zcl_acronym DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS parse IMPORTING phrase         TYPE string
                  RETURNING VALUE(acronym) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_acronym IMPLEMENTATION.
  METHOD parse.
    "Implement solution
    DATA(phrase_local) = phrase.
    DATA(replacement_tab) = VALUE string_table( ( `-` ) ( `_` ) ).

    LOOP AT replacement_tab ASSIGNING FIELD-SYMBOL(<replacement>).
      REPLACE ALL OCCURRENCES OF <replacement> IN phrase_local WITH ` `.
    ENDLOOP.

    SPLIT phrase_local AT space INTO TABLE DATA(words).
    LOOP AT words ASSIGNING FIELD-SYMBOL(<word>).
      CHECK <word> <> space.
      acronym = acronym && to_upper( <word>+0(1) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
