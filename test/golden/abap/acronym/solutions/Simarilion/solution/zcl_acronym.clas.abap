CLASS zcl_acronym DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS parse IMPORTING phrase         TYPE string
                  RETURNING VALUE(acronym) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
  METHODS clean
  IMPORTING
  phrase        TYPE string
  RETURNING
VALUE(clean_phrase) TYPE string.

ENDCLASS.



CLASS zcl_acronym IMPLEMENTATION.
  METHOD parse.
    "Implement solution
 DATA(lv_phrase) = clean( phrase).

  SPLIT lv_phrase AT ' ' INTO TABLE DATA(lt_phrase).

  LOOP AT lt_phrase ASSIGNING FIELD-SYMBOL(<lt_phrase>).
    IF <lt_phrase> IS ASSIGNED.
    acronym = acronym && <lt_phrase>+0(1).
    ENDIF.
  ENDLOOP.
ENDMETHOD.

METHOD clean.
clean_phrase = phrase.

REPLACE ALL OCCURRENCES OF REGEX |[,!\{}&@#$%^&*()_+=':;/.?0123456789]| IN clean_phrase WITH ||.

REPLACE ALL OCCURRENCES OF '"'  IN clean_phrase  WITH ''.
REPLACE ALL OCCURRENCES OF '''' IN clean_phrase WITH ''.

TRANSLATE clean_phrase using '- _ '.
CONDENSE clean_phrase.

SHIFT clean_phrase LEFT DELETING LEADING space.
TRANSLATE clean_phrase TO UPPER CASE.
  ENDMETHOD.

ENDCLASS.
