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
    phrase = to_upper( phrase ).
    REPLACE ALL OCCURRENCES OF `'`  IN phrase WITH ``.

    DO strlen( phrase ) TIMES.
      DATA(f_char) = substring( val = phrase off = sy-index - 1 len = 1 ).

      IF sy-index EQ 1.
        acronym = acronym && f_char.
      ENDIF.

      IF sy-abcde NA f_char.

        DATA(letter_acronym) = substring( val = phrase off = sy-index len = 1 ).
        IF sy-abcde CA letter_acronym.
          acronym = acronym && letter_acronym.
        ENDIF.
      ENDIF.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
