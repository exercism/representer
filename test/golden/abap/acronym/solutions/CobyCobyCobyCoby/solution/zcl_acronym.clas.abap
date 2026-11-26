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
    DATA words TYPE string_table.
    REPLACE ALL OCCURRENCES OF REGEX '[^a-zA-Z\s-]' IN phrase WITH ''.
    REPLACE ALL OCCURRENCES OF REGEX '[-\s]+' IN phrase WITH '-'.
    SPLIT phrase AT '-' INTO TABLE words.
    acronym = REDUCE string( INIT str TYPE string
                             FOR word IN words
                             NEXT str = str && to_upper( word(1) ) ).
  ENDMETHOD.
ENDCLASS.
