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
    "Translate to upper case
    TRANSLATE phrase TO UPPER CASE.

    "manage special characters
    REPLACE ALL OCCURRENCES OF REGEX '\\n|[,.;:!?()&@$%^-]' IN phrase WITH '_'.

    "words in parenthesis
    REPLACE ALL OCCURRENCES OF `'` IN phrase WITH space.
    
    "input to table
    phrase = translate( val = phrase from = '_'  to = ` ` ).
    CONDENSE phrase.
    SPLIT phrase AT space INTO TABLE DATA(itab_phrase).

    LOOP AT itab_phrase ASSIGNING FIELD-SYMBOL(<word>).
      acronym = acronym && <word>(1).
    ENDLOOP.
    
  
  ENDMETHOD.
ENDCLASS.
