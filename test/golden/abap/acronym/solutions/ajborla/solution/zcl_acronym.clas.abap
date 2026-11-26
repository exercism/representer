* ----------------------------------------------------------------------------
* exercism.io
* ABAP Track Exercise: acronym
* Contributed: Anthony J. Borla (ajborla@bigpond.com)
* ----------------------------------------------------------------------------

CLASS zcl_acronym DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS parse
      IMPORTING phrase         TYPE string
      RETURNING VALUE(acronym) TYPE string.

  PRIVATE SECTION.
    METHODS clean
      IMPORTING
        text                   TYPE string
      RETURNING
        VALUE(clean_text)      TYPE string.

ENDCLASS.

CLASS zcl_acronym IMPLEMENTATION.

  METHOD parse.
    " Require a series of SPACE-separated, upper-case words
    DATA(lv_words) = clean( phrase ). 

    " Split string on SPACE boundaries
    SPLIT lv_words AT SPACE
      INTO TABLE DATA(lt_words).

    " Concatenate the 1st letter of each word
    LOOP AT lt_words ASSIGNING FIELD-SYMBOL(<word>).
      acronym = acronym && <word>+0(1).
    ENDLOOP.
  ENDMETHOD.

  METHOD clean.
    clean_text = text.

    " Remove non-alpha except for SPACE and HYPHEN
    REPLACE ALL OCCURRENCES OF REGEX |[,!\{}&@#$%^&*()_+=':;/.?0123456789]|
      IN clean_text WITH ||.

    " Remove all quote characters
    REPLACE ALL OCCURRENCES OF '"' IN clean_text WITH ''.
    REPLACE ALL OCCURRENCES OF '''' IN clean_text WITH ''.

    " Convert hyphens and underscores to spaces, then normalize spaces
    TRANSLATE clean_text using '- _ '.
    CONDENSE clean_text.

    " Ensure leading space is trimmed
    SHIFT clean_text LEFT DELETING LEADING SPACE.

    " Uppercase remaining characters
    TRANSLATE clean_text TO UPPER CASE.
  ENDMETHOD.

ENDCLASS.
